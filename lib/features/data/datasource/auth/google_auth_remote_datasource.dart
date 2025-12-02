import 'package:chatbox/features/domain/entities/auth/google_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthRemoteDatasource {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn gSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<GoogleEntities?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await gSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user;

      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': user.email ?? '',
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        final userDoc = await firestore.collection('users').doc(user.uid).get();
        final userData = userDoc.data();

        return GoogleEntities(
          userId: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          photoUrl: user.photoURL,
          phoneNumber: userData?['phoneNumber'],
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updatePhoneNumber(String userId, String phoneNumber) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfUserHasPhoneNumber(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['phoneNumber'] != null &&
               (data!['phoneNumber'] as String).isNotEmpty;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await gSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
