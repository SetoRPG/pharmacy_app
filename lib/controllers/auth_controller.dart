import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Step 1: Register user with email and password
  Future<User?> signUpWithEmailPassword(
      String email, String password, String userName) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Update display name for the user
        await user.updateDisplayName(userName);
        await user.reload(); // Reload the user to apply display name changes
        user = _auth.currentUser; // Get updated user info
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("Error during registration: ${e.message}");
      return null;
    }
  }

  // Additional methods for sign in, password change, etc. will be added later
}
