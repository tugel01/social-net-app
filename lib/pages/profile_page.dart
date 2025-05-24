import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/components/my_back_button.dart';
import 'package:social_media_app/components/my_posts_builder.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail;
  const ProfilePage({super.key, required this.userEmail});

  Future<void> uploadImageAndSaveToFirestore(BuildContext context, String? imageUrl) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);
      final bool fileExists = await imageFile.exists();
      if (!fileExists) throw Exception('Selected file does not exist');

      final String fileName =
          '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(fileName);

      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'uploadedBy': user.uid},
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state != TaskState.success) {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }

      final String downloadURL = await storageRef.getDownloadURL();
      debugPrint('Download URL: $downloadURL');

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .update({'imageUrl': downloadURL});

      final String? oldImageUrl = imageUrl;
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
          debugPrint('Old image deleted successfully');
        } catch (e) {
          debugPrint('Could not delete old image: $e');
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Error in upload: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Users')
              .doc(userEmail)
              .snapshots(),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle errors
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('User not found'));
        }

        // Extract data from snapshot
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final username = userData['username'] ?? 'No username';
        final email = userData['email'] ?? 'No email';
        final imageUrl = userData['imageUrl'];

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 25),
                child: const Row(children: [MyBackButton()]),
              ),
              const SizedBox(height: 25),

              GestureDetector(
                onTap: () => uploadImageAndSaveToFirestore(context, imageUrl),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(25),
                  child:
                      userData['imageUrl'] == null
                          ? const Icon(Icons.person, size: 64)
                          : Image.network(
                            userData['imageUrl'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(height: 25),

              // Username
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),

              // Email
              Text(
                email,
                style: const TextStyle(
                  color: Color.fromARGB(255, 120, 120, 120),
                ),
              ),
              const SizedBox(height: 25),

              // Posts (pass the current email to filter posts)
              MyPostsBuilder(searchQuery: '', username: username),
            ],
          ),
        );
      },
    );
  }
}
