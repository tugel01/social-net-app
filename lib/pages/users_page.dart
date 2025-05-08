import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_back_button.dart';
import 'package:social_media_app/components/my_list_tile.dart';
import 'package:social_media_app/helper/helper_function.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 25),
                child: Row(children: [MyBackButton()]),
              ),
              SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    String username = user['username'];
                    String email = user['email'];
                    return MyListTile(title: username, subtitle: email);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
