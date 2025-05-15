import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPwrdController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwrdController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // check passwords match
    if (passwordController.text != confirmPwrdController.text) {
      // pop loading circle
      Navigator.pop(context);
      // error message for user
      displayMessageToUser('Passwords don\'t match', context);
    } else {
      Navigator.pop(context);

      // create a user
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        await userCredential.user?.updateDisplayName(usernameController.text);
        await userCredential.user?.reload();

        // create user document and store to firestore
        createUserDocument(userCredential);
      } on FirebaseAuthException catch (e) {
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.person_4,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 25),

                // app name
                const Text("A P P N A M E", style: TextStyle(fontSize: 20)),

                const SizedBox(height: 25),

                // username textfield
                MyTextfield(
                  hintText: 'Your username',
                  obscureText: false,
                  controller: usernameController,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextfield(
                  hintText: 'Your email',
                  obscureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextfield(
                  hintText: 'Your password',
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 10),

                // confirmPassword textfield
                MyTextfield(
                  hintText: 'Confirm your password',
                  obscureText: true,
                  controller: confirmPwrdController,
                ),

                const SizedBox(height: 35),

                // sign up button
                MyButton(text: 'Sign up', onTap: registerUser),

                const SizedBox(height: 15),

                // don't have an account? Sign up here
                Row(
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        ' Sign in here',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
