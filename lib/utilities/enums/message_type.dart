import 'package:firebase_auth/firebase_auth.dart';

enum MessageType {
  sended,
  received;

  static MessageType getMessageType({required String messageSenderName}) =>
      FirebaseAuth.instance.currentUser?.displayName == messageSenderName
      ? .sended
      : .received;
}
