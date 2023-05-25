import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/households.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/services/user.dart';

class HomePage extends StatefulWidget {
  late final User currentUser;

  HomePage({super.key}) {
    currentUser = UserService.instance.currentUser!;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${widget.currentUser.fname}!',
        ),
      ),
      body: widget.currentUser.households.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.block,
                    size: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('You are not in any households!')
                ],
              ),
            )
          : FutureBuilder<List<Household>>(
              future: APIService.instance
                  .getHouseholds(widget.currentUser.households),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HouseholdPage(
                                    household: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(snapshot.data![index].name),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
    );
  }
}
