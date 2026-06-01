import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Stream etat de connexion
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // utilisateure cureent
  User? get cureentUser => _auth.currentUser;
  // function login

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  // function register
  Future<String?> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(displayName.trim());
      return null; // null=success
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  // function resetPassword

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  // function logout

  Future<void> logout() async {
    await _auth.signOut();
  }
}
