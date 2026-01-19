import 'package:chat_app/utilities/extensions/firebase_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final instance = AuthService._();
  AuthService._();
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseException catch (error) {
      throw error.firebaseMessage;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (error) {
      throw error.firebaseMessage;
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
    } on FirebaseException catch (error) {
      throw error.firebaseMessage;
    }
  }
}
