import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/pages/home/user_provider.dart';
import 'package:inventory/widgets/household_tile.dart';
import 'package:provider/provider.dart';

class HouseholdList extends StatelessWidget {
  const HouseholdList({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);
    final List<Household>? households = provider.housholds;

    if (households == null) {
      provider.refresh();
    }

    if (households == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (households.isEmpty) {
      return const Center(
        child: Text('No households found'),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await Provider.of<UserProvider>(
            context,
            listen: false,
          ).refresh();
        },
        child: ListView.builder(
          itemCount: households.length,
          itemBuilder: (context, index) {
            return HouseholdTile(
              household: households[index],
            );
          },
        ),
      );
    }
  }
}
