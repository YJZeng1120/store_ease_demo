import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class FirebaseApi {
  Future<Option<String>> loginUser(
    final String email,
    final String password,
  ) async {
    try {
      await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return none();
    } on FirebaseAuthException catch (e) {
      return some(e.code);
    }
  }

  Future<Option<String>> verifyUser(
    final String email,
    final String password,
  ) async {
    try {
      final User user = firebase.currentUser!;
      final AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      ); // 建立重新驗證所需的憑證。
      await user.reauthenticateWithCredential(credential); // 帳戶驗證
      return none();
    } on FirebaseAuthException catch (e) {
      return some(e.code);
    }
  }

  Future<String> getUid() async {
    return firebase.currentUser!.uid;
  }

  User? getCurrentUser() {
    return firebase.currentUser;
  }

  Future<Option<String>> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return none();
    } on FirebaseAuthException catch (e) {
      return some(e.code);
    }
  }
}
