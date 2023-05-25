import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/services/user.dart';

class HouseholdProvider extends ChangeNotifier {
  List<Household>? _households;

  HouseholdProvider() {
    refresh();
    UserService.instance.addListener(refresh);
  }

  Future<void> refresh() async {
    _households = await APIService.instance.getHouseholds(
      UserService.instance.currentUser!.households,
    );
    notifyListeners();
  }

  List<Household>? get housholds => _households;
}
