import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // streams change of user state

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // register with mail and password

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign in with credentials

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with google
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User user = userCredential.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;

      assert(currentUser.uid == user.uid);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign out

  Future signOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
