import 'package:firebase_core/firebase_core.dart';

extension FirebaseExceptionExtension on FirebaseException {
  String get firebaseMessage {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for the provided email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'email-already-in-use':
        return 'The email is already in use by another account.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'invalid-credential':
        return 'The password or email is incorrect.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your internet connection.';
      default:
        return code;
    }
  }
}
