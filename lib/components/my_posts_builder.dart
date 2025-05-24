import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_post_tile.dart';
import 'package:social_media_app/database/firestore.dart';

class MyPostsBuilder extends StatelessWidget {
  final String? username;
  final String searchQuery;
  final FirestoreDatabase database = FirestoreDatabase();
  MyPostsBuilder({super.key, required this.searchQuery, this.username});

  void editPost(BuildContext context, dynamic post) {
    final editController = TextEditingController(text: post['PostMessage']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(controller: editController),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(text: 'Cancel', onTap: () => Navigator.pop(context)),
                MyButton(
                  text: 'Save',
                  onTap: () {
                    final text = editController.text;
                    Navigator.pop(context);
                    Future.microtask(() async {
                      await database.editPost(post['postId'], text);
                      editController.dispose();
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // if it is general feed, get all posts. If it is profile page, get this user's posts
      stream:
          username == null
              ? database.getPostsStream(searchQuery)
              : FirebaseFirestore.instance
                  .collection("Posts")
                  .orderBy('TimeStamp', descending: true)
                  .where('UserName', isEqualTo: username)
                  .snapshots(),
      builder: (context, snapshot) {
        // loading circle
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // get all posts
        final posts = snapshot.data!.docs;
        // no data
        if (snapshot.data == null || posts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Text('No posts'),
            ),
          );
        }

        // return as a list
        return Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              String postId = post['postId'];
              String message = post['PostMessage'];
              String userEmail = post['UserEmail'];
              Timestamp timestamp = post['TimeStamp'];
              String username = post['UserName'];

              return MyPostTile(
                // If it is current user's post write 'You'
                isCurrentUserPost:
                    (userEmail == FirebaseAuth.instance.currentUser?.email),
                username:
                    (username == FirebaseAuth.instance.currentUser?.displayName)
                        ? 'You'
                        : username,
                message: message,
                email: userEmail,
                time: timestamp,
                onDeletePressed: (value) {
                  database.deletePost(postId);
                },
                onEditPressed: (context) => editPost(context, post),
              );
            },
          ),
        );
      },
    );
  }
}
