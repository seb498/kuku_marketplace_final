import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register a new user
  Future<User?> register(
    String email,
    String password,
    String role,
    String name,
    String phone,
  ) async {
    try {
      // ✅ Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // ✅ Save user details to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': role,
          'name': name,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return user; // ✅ Success
      }
    } catch (e) {
      print('Registration error: $e');
      return null; // ✅ Something failed
    }

    return null; // Just in case
  }

  /// Sign in user
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
