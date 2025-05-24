import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_drawer.dart';
import 'package:social_media_app/components/my_post_button.dart';
import 'package:social_media_app/components/my_posts_builder.dart';
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

  // search query. empty by default
  var searchQuery = '';
  // controllers
  final TextEditingController newPostController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    newPostController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      database.addPost(newPostController.text);
    }

    newPostController.clear();
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
                // box
                Expanded(
                  child: MyTextfield(
                    hintText: 'Say something',
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                // button
                PostButton(onTap: postMessage),
              ],
            ),
          ),
          // Box for user to search
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 25),
            child: Row(
              children: [
                // Textfield to type in search request
                Expanded(
                  child: MyTextfield(
                    hintText: 'Or search posts that begin with...',
                    obscureText: false,
                    controller: searchController,
                  ),
                ),

                // Search button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      searchQuery = searchController.text;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Posts
          MyPostsBuilder(searchQuery: searchQuery),
        ],
      ),
    );
  }
}
