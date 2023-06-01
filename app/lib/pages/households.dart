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
      appBar: AppBar(
        title: Text(widget.household.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Main House'),
                  subtitle: Text('Co-owners:'),
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





//this page is for showing curent state of the household, direct to an add items page and it 