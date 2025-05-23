import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_back_button.dart';
import 'package:social_media_app/components/my_list_tile.dart';
import 'package:social_media_app/helper/helper_function.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // search request. empty by default
  String searchUser = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // back button
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 25),
            child: Row(children: [MyBackButton()]),
          ),
          const SizedBox(height: 40),

          // search box
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchUser = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search users',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // list of users
          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection("Users")
                    .orderBy('username')
                    .startAt([searchUser])
                    .endAt([searchUser + "\uf8ff"])
                    .snapshots(),
            builder: (context, snapshot) {
              // errors
              if (snapshot.hasError) {
                displayMessageToUser('Something went wrong', context);
              }

              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == null) {
                return const Text('No Data');
              }
              // all users
              final users = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    String username = user['username'];
                    String email = user['email'];
                    return MyListTile(
                      onTapp: () {
                        Navigator.pushNamed(
                          context,
                          'profile_page',
                          arguments: email,
                        );
                      },
                      title: username,
                      subtitle: email,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
