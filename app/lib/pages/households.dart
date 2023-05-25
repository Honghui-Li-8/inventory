import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';

class HouseholdPage extends StatefulWidget {
  final Household household;
  const HouseholdPage({super.key, required this.household});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.household.name)),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Main House'),
                ),
                ListTile(
                  title: Text('Main House'),
                ),
                ListTile(
                  title: Text('Main House'),
                ),
                ListTile(
                  title: Text('Main House'),
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('you homeless sorry'),
            ),
          ),
        ],
      ),
    );
  }
}
