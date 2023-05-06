import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/user.dart';

class APIService {
  static const bool _testing = false;
  static const String _baseUrl = _testing
      // ? 'http://168.150.111.230:8080'
      ? 'http://192.168.50.146:8080'
      // ? 'http://168.150.60.67:8080'
      : 'https://inventory-paradise.wl.r.appspot.com';
  static APIService? _instance;

  static APIService get instance {
    _instance ??= APIService._();
    return _instance!;
  }

  APIService._();

  Future<User> getCurrentUser(String uid) async {
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
}
