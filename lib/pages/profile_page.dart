import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_back_button.dart';
import 'package:social_media_app/components/my_post_tile.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final username = userData['username'] ?? 'No username';
    final email = userData['email'] ?? 'No email';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 25),
            child: const Row(children: [MyBackButton()]),
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(25),
            child: const Icon(Icons.person, size: 64),
          ),
          const SizedBox(height: 25),
          Text(
            username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            email,
            style: const TextStyle(
              color: Color.fromARGB(255, 120, 120, 120),
            ),
          ),
          const SizedBox(height: 25),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Posts")
                  .orderBy('TimeStamp', descending: true)
                  .where('UserName', isEqualTo: username)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final posts = snapshot.data?.docs ?? [];

                if (posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text('No posts'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index].data();
                    String message = post['PostMessage'] ?? '';
                    String userEmail = post['UserEmail'] ?? '';
                    Timestamp timestamp = post['TimeStamp'] ?? Timestamp.now();
                    String username = post['UserName'] ?? '';

                    return MyPostTile(
                      isCurrentUserPost: false, // or compare with current user if needed
                      username: username,
                      message: message,
                      email: userEmail,
                      time: timestamp,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
