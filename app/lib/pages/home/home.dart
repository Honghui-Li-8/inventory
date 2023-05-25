import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/add_houshold/add_household.dart';
import 'package:inventory/pages/home/household_list.dart';
import 'package:inventory/pages/home/households_provider.dart';
import 'package:inventory/services/user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  late final User currentUser;

  HomePage({super.key}) {
    currentUser = UserService.instance.currentUser!;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const HouseholdList(),
    const Text('Settings'),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HouseholdProvider>(
          create: (context) => HouseholdProvider(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Welcome ${widget.currentUser.fname}!',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddHouseholdPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Households',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
