import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  // Sign in with Google
  Future<CustomUser?> signInWithGoogle() async {
    try {
      // Start Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled the login

      // Authenticate with Firebase using the Google credentials
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) return null; // Firebase authentication failed

      // Create a CustomUser object
      CustomUser customUser = CustomUser(
        uid: user.uid,
        displayName: user.displayName ?? 'No Name', // Fallback if displayName is null
        email: user.email ?? 'No Email', // Fallback if email is null
        photoUrl: user.photoURL ?? '', // Fallback if photoURL is null
      );

      // Check if user already exists in Firestore, and save to Firestore if not
      await _saveUserToFirestore(customUser);

      return customUser;
    } catch (e) {
      // Handle sign-in errors (e.g., network issues, Firebase errors)
      print("Error during Google Sign-In: ${e.toString()}");
      rethrow; // Re-throw error to be handled in the calling code
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print("Error during sign out: ${e.toString()}");
      rethrow; // Re-throw error to be handled in the calling code
    }
  }

  // Get current user
  CustomUser? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;

    // Return CustomUser with Firebase User data
    return CustomUser(
      uid: user.uid,
      displayName: user.displayName ?? 'No Name', // Fallback if displayName is null
      email: user.email ?? 'No Email', // Fallback if email is null
      photoUrl: user.photoURL ?? '', // Fallback if photoURL is null
    );
  }

  // Save user data to Firestore
  Future<void> _saveUserToFirestore(CustomUser user) async {
    try {
      // Save or update user document in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
      });
    } catch (e) {
      print("Error saving user to Firestore: ${e.toString()}");
      rethrow; // Re-throw error to be handled in the calling code
    }
  }
}
