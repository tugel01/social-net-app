import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_drawer.dart';
import 'package:social_media_app/components/my_textfield.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // controller
  TextEditingController newPostController = TextEditingController();

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
            child: MyTextfield(
              hintText: 'Say something',
              obscureText: false,
              controller: newPostController,
            ),
          ),
        ],
      ),
    );
  }
}
