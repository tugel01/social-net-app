/* 

Database to store posts published by users
They are stored in collection "Posts" in firebase

Each post contains:
- message
- email
- timestamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;
  // collection of posts
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    "Posts",
  );
  // post a message
  Future<void> addPost(String message) {
    user?.reload();
    return posts.add({
      'UserName': user!.displayName,
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read posts from db
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream =
        FirebaseFirestore.instance
            .collection("Posts")
            .orderBy('TimeStamp', descending: true)
            .snapshots();
    return postsStream;
  }
}
