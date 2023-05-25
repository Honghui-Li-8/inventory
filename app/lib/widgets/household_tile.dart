import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';

class HouseholdTile extends StatelessWidget {
  final Household household;

  const HouseholdTile({super.key, required this.household});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(household.name),
      subtitle: Text(household.owner),
    );
  }
}
