import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_back_button.dart';
import 'package:social_media_app/components/my_posts_builder.dart';

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
          // back button
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 25),
            child: const Row(children: [MyBackButton()]),
          ),
          const SizedBox(height: 25),

          // photo (Icon for now)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(25),
            child: const Icon(Icons.person, size: 64),
          ),
          const SizedBox(height: 25),

          // username
          Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 10),

          // email
          Text(
            email,
            style: const TextStyle(color: Color.fromARGB(255, 120, 120, 120)),
          ),
          const SizedBox(height: 25),
          
          // posts
          MyPostsBuilder(searchQuery: '', username: username),
        ],
      ),
    );
  }
}
