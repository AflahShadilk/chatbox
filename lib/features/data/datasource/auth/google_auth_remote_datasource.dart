import 'package:chatbox/features/domain/entities/auth/google_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthRemoteDatasource {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn gSignIn = GoogleSignIn();

  Future<GoogleEntities?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await gSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user;
      if (user != null) {
        return GoogleEntities(
            userId: user.uid,
            email: user.email ?? '',
            name: user.displayName,
            photoUrl: user.photoURL);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  Future<void>signOut()async{
    await gSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
