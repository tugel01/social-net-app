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
  Future<void> addPost(String message) async {
    if (user == null) return;

    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    DocumentReference postRef = posts.doc();

    await postRef.set({
      'postId': postRef.id,
      'UserName': user!.displayName ?? 'Unknown',
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  Future<void> deletePost(String postId) async {
    await posts.doc(postId).delete();
  }

  Future<void> editPost(String postId, String newText) async {
    final oldPostRef = posts.doc(postId);
    await oldPostRef.update({
      'PostMessage': newText,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read posts from db
  Stream<QuerySnapshot> getPostsStream(String searchPost) {
    if (searchPost == '') {
      final postsStream =
          FirebaseFirestore.instance
              .collection("Posts")
              .orderBy('TimeStamp', descending: true)
              .snapshots();
      return postsStream;
    }

    final postsds =
        FirebaseFirestore.instance
            .collection("Posts")
            .orderBy('PostMessage')
            .startAt([searchPost])
            .endAt([searchPost + "\uf8ff"])
            .snapshots(); // FIGURE IT OUT LATER (SEARCH)
    return postsds;
  }
}
