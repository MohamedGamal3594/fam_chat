import 'package:firebase_auth/firebase_auth.dart';

class Message {
  final String senderName;
  final DateTime createdAt;
  final String text;

  Message({
    required this.senderName,
    required this.createdAt,
    required this.text,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderName: json['senderName'] as String,
      createdAt: json['createdAt'].toDate() as DateTime,
      text: json['text'] as String,
    );
  }

  static Map<String, dynamic> createNewMessageJson({required String text}) {
    return {
      'senderName': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
      'createdAt': DateTime.now(),
      'text': text,
    };
  }
}
