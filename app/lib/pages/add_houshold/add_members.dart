import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/util/wait.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/widgets/user_tile.dart';

class AddMembersPage extends StatefulWidget {
  final String householdName;
  final Uint8List? imageBytes;

  const AddMembersPage({
    super.key,
    required this.householdName,
    this.imageBytes,
  });

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final TextEditingController _emailController = TextEditingController();
  final List<UserTile?> _userTiles = [];
  final List<User> _users = [];

  void _handleStateChange(UserState state, User? data) {
    if (state == UserState.found) {
      _users.add(data!);
    }
  }

  void _handleDelete(int idx) {
    setState(() {
      _userTiles[idx] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add members to ${widget.householdName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.person_add_alt,
                  ),
                  onPressed: () {
                    setState(() {
                      _userTiles.add(
                        UserTile(
                          email: _emailController.text,
                          id: _userTiles.length,
                          onDelete: _handleDelete,
                          onStateChange: _handleStateChange,
                        ),
                      );
                      _emailController.clear();
                    });
                  },
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: _userTiles.whereType<UserTile>().toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 4),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaitScreen(
                          future: APIService.instance.createHousehold(
                            name: widget.householdName,
                            image: widget.imageBytes,
                            invitees: _users,
                          ),
                          onSuccess: (_) {
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                          }),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Create Household & Invite Members'),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
