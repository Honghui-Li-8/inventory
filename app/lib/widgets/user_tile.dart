import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/api.dart';

enum UserState { loading, found, notFound }

class UserTile extends StatefulWidget {
  final String email;
  final int id;
  final void Function(int) onDelete;
  final void Function(UserState, User?) onStateChange;
  const UserTile({
    super.key,
    required this.email,
    required this.id,
    required this.onDelete,
    required this.onStateChange,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  UserState _state = UserState.loading;
  User? user;

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  Future<void> _loadUser() async {
    User? user = await APIService.instance.userExists(widget.email);
    if (user == null) {
      setState(() {
        _state = UserState.notFound;
      });
    } else {
      setState(() {
        this.user = user;
        _state = UserState.found;
      });
    }
    widget.onStateChange(_state, user);
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case UserState.loading:
        return Card(
          child: ListTile(
            leading: const CircularProgressIndicator(),
            title: Text(widget.email),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                widget.onDelete(widget.id);
              },
            ),
          ),
        );
      case UserState.found:
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text("${user!.fname} ${user!.lname}"),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                widget.onDelete(widget.id);
              },
            ),
          ),
        );
      case UserState.notFound:
        return Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: ListTile(
            leading: const Icon(Icons.error),
            title: Text(
              "${widget.email.length > 18 ? "${widget.email.substring(0, 15)}..." : widget.email} not found",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                widget.onDelete(widget.id);
              },
            ),
          ),
        );
    }
  }
}
