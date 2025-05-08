import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwrdController = TextEditingController();
  
  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
              Text("A P P N A M E", style: TextStyle(fontSize: 20)),

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

              const SizedBox(height: 10),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // sign up button
              MyButton(text: 'Sign up', onTap: register),

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
                    onTap: onTap,
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
    );
  }
}
