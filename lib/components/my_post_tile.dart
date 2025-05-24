import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:social_media_app/helper/helper_function.dart';

class MyPostTile extends StatelessWidget {
  final String username;
  final String email;
  final String message;
  final Timestamp time;
  final bool isCurrentUserPost;
  final Function(BuildContext)? onDeletePressed;
  final Function(BuildContext)? onEditPressed;

  const MyPostTile({
    super.key,
    required this.time,
    required this.username,
    required this.email,
    required this.message,
    required this.isCurrentUserPost,
    this.onDeletePressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    // default widget
    Widget postContent = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color:
                            (username == 'You')
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  children: [
                    Text(
                      getTimeFromStamp(time),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      getDateFromStamp(time),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // If it is current user's post, add slidable actions
    return isCurrentUserPost
        ? Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: onEditPressed,
                  icon: Icons.edit,
                  label: 'Edit',
                  backgroundColor: Colors.yellow.shade800,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: onDeletePressed,
                  icon: Icons.delete,
                  label: 'Delete',
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            child: postContent,
          ),
        )
        : Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: postContent,
        );
  }
}
