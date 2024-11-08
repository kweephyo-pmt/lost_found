import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential =
            await _auth.signInWithCredential(credential);
        await storeUserData(userCredential.user);
        return userCredential;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      // Add a proper error handling here (e.g., show a message to the user)
    }
    return null;
  }

  Future<void> storeUserData(User? user) async {
    if (user != null) {
      final userDataSnapshot =
          await FirebaseFirestore.instance.collection("Users").doc(user.email).get();
      if (!userDataSnapshot.exists) {
        await FirebaseFirestore.instance.collection("Users").doc(user.email).set({
          'username': user.displayName ?? user.email!.split('@')[0],
          'bio': 'Empty bio...',
        });
      }
    }
  }
}
