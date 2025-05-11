import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void displayMessageToUser(String text, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(title: Text(text)),
  );
}

String getDateFromStamp(Timestamp timestamp) {
  String date = DateFormat('d MMM').format(timestamp.toDate());
  return date;
}

String getTimeFromStamp(Timestamp timestamp) {
  String time = DateFormat('kk:mm').format(timestamp.toDate());
  return time;
}
