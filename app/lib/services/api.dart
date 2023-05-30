import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/models/inventory.dart';
import 'package:inventory/models/invitation.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/user.dart';

class APIService {
  static const bool _testing = false;
  static const String _baseUrl = _testing
      // ? 'http://168.150.111.230:8080'
      ? "https://9fcf-168-150-43-81.ngrok-free.app"
      // ? 'http://168.150.60.67:8080'
      : 'https://inventory-paradise.wl.r.appspot.com';
  static APIService? _instance;

  static APIService get instance {
    _instance ??= APIService._();
    return _instance!;
  }

  APIService._();

  Future<User> getUser(String uid) async {
    String url = '$_baseUrl/users/$uid';
    Response res = await get(Uri.parse(url));
    return User.fromJson(jsonDecode(res.body));
  }

  Future<void> createUser(User user) async {
    String url = '$_baseUrl/users';
    log(jsonEncode(user.toJson()));
    await post(
      Uri.parse(url),
      body: jsonEncode(user.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    UserService.instance.refresh();
  }

  Future<List<Household>> getHouseholds(List<String> households) {
    String url = '$_baseUrl/getHouseholds';
    return post(
      Uri.parse(url),
      body: jsonEncode(households),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((res) {
      List<dynamic> json = jsonDecode(res.body);
      return json.map((e) => Household.fromJson(e)).toList();
    });
  }

  Future<User?> userExists(String email) async {
    String url = '$_baseUrl/users/exists';
    return post(Uri.parse(url),
        body: jsonEncode({"email": email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }).then((value) {
      if (value.body.isEmpty) {
        return null;
      } else {
        return User.fromJson(jsonDecode(value.body));
      }
    });
  }

  Future<void> createHousehold({
    required String name,
    required Uint8List? image,
    required List<User> invitees,
  }) async {
    // String imageUrl = await FirebaseService.uploadImage(
    //     imageData: image ??= Uint8List(0), folder: "household_photos");

    Household newHousehold = Household(
      name: name,
      owner: UserService.instance.currentUser!.uid,
      // imageUrl: imageUrl,
      inventory: "",
      members: [UserService.instance.currentUser!.uid],
      outgoingInvitations: [],
    );

    String url = '$_baseUrl/households';
    Response res = await post(
      Uri.parse(url),
      body: jsonEncode(newHousehold.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    String householdId = jsonDecode(res.body)["id"];
    await createInvitaions(householdId, invitees);
    await UserService.instance.refresh();
  }

  Future<Response> createInvitaions(String household, List<User> users) async {
    String url = '$_baseUrl/households/$household/invite';
    return post(
      Uri.parse(url),
      body: jsonEncode({
        "sender": UserService.instance.currentUser!.uid,
        "invitees": users.map((e) => e.uid).toList(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<Inventory> getInventoryItems(String ID) {
    String url = '$_baseUrl/inventory/$ID';
    return get(Uri.parse(url)).then(
      (value) => Inventory.fromJson(
        jsonDecode(value.body),
      ),
    );
  }

  Future<List<Invitation>> getInvitations(List<String> invitationIds) {
    String url = '$_baseUrl/getInvitations';
    return post(
      Uri.parse(url),
      body: jsonEncode(invitationIds),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((res) {
      List<dynamic> json = jsonDecode(res.body);
      return json.map((e) => Invitation.fromJson(e)).toList();
    });
  }

  Future<void> acceptInvitation(Invitation invitaion, String id) async {
    String url = '$_baseUrl/invitations/$id/update';
    await post(
      Uri.parse(url),
      body: jsonEncode({"status": "accepted"}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    await UserService.instance.refresh();
  }

  Future<void> declineInvitation(Invitation invitaion, String id) async {
    String url = '$_baseUrl/invitations/$id/update';
    await post(
      Uri.parse(url),
      body: jsonEncode({"status": "declined"}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    await UserService.instance.refresh();
  }

  Future<void> setHouseholdMembers(String householdId, List<String> members) {
    String url = '$_baseUrl/households/$householdId/updateMembers';
    return post(
      Uri.parse(url),
      body: jsonEncode(members),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<void> editMembers({
    required Household household,
    required String householdId,
    required List<User> members,
  }) async {
    List<String> newMemberIds = [];
    List<String> removedMembers = [];

    for (var member in members) {
      if (!household.members.contains(member.uid)) {
        newMemberIds.add(member.uid);
      }
    }

    List<User> newMembers = [];
    for (var member in newMemberIds) {
      newMembers.add(await getUser(member));
    }

    for (var member in household.members) {
      if (!members.map((e) => e.uid).contains(member)) {
        removedMembers.add(member);
      }
    }

    household.members
        .removeWhere((element) => removedMembers.contains(element));

    print(newMembers);
    await createInvitaions(householdId, newMembers);
    await setHouseholdMembers(householdId, household.members);
  }
}
