import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//regiser
class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<User?> register(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()), backgroundColor: Colors.red));
    } catch (e) {
      print(e);
    }
  }

//Login
  Future<User?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()), backgroundColor: Colors.red));
    } catch (e) {
      print(e);
    }
  } //google sign in

  Future<User?> SignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              //    clientId:
              //      '186089200190-254a748aucsv44gbafrq677qbo1qu4tl.apps.googleusercontent.com'
              )
          .signIn();
      if (googleUser != null) {
        //obtai the auth request form the details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ); // Once sign in return the user data from firebase
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future signout() async {
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
