import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_drawer.dart';
import 'package:social_media_app/components/my_post_button.dart';
import 'package:social_media_app/components/my_post_tile.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/database/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // controller
  final TextEditingController newPostController = TextEditingController();

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      database.addPost(newPostController.text);
    }

    newPostController.clear();
  }

  void deletePost(String postId) {
    database.deletePost(postId);
  }

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('F E E D'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // Box for user to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextfield(
                    hintText: 'Say something',
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                PostButton(onTap: postMessage),
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStream(),
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
                      isCurrentUserPost:
                          (userEmail ==
                              FirebaseAuth.instance.currentUser?.email),
                      username:
                          (username ==
                                  FirebaseAuth
                                      .instance
                                      .currentUser
                                      ?.displayName)
                              ? 'You'
                              : username,
                      message: message,
                      email: userEmail,
                      time: timestamp,
                      onDeletePressed: (value) => deletePost(postId),
                      onEditPressed: (context) => editPost(context, post),
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
