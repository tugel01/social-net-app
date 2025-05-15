import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Reset Password"),
      content: TextField(
        controller: emailController,
        decoration: InputDecoration(hintText: "Enter your email"),
      ),
      actions: [
        TextButton(
          child: Text(
            "Send Reset Link",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          onPressed: () async {
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: emailController.text.trim(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Reset email sent")));
            } on FirebaseAuthException catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
            }
          },
        ),
      ],
    );
  }
}
