import 'package:chat_app/models/message.dart';
import 'package:chat_app/utilities/extensions/firebase_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesService {
  MessagesService._();
  static final instance = MessagesService._();

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Future<void> sendMessage({required String text}) async {
    try {
      final messageJson = Message.createNewMessageJson(text: text);
      await FirebaseFirestore.instance.collection('messages').add(messageJson);
    } on FirebaseException catch (error) {
      throw error.firebaseMessage;
    }
  }

  Future<void> deleteMessage({required String messageId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .delete();
    } on FirebaseException catch (error) {
      throw error.firebaseMessage;
    }
  }
}
