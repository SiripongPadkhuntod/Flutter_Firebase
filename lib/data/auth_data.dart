// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_project6402262/data/user_data.dart';

abstract class AuthData {
  Future<void> signUp(String email, String password, String conpassword);
  Future<void> signIn(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> forgotPassword(String email);
  Future<void> signOut();

}

class AuthRemote implements AuthData {
  @override
  Future signUp(String email, String password, String conpassword) async {
    try {
      print('email: $email, password: $password, conpassword: $conpassword');
      if (email == '' || password == '' || conpassword == '') {
        print('Please fill in the email and password');
      } else {
        if (conpassword == password) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          print('Sign up with email: $email, password: $password');
          //insert data to firestore
          await UserRemote().addDataNew();
        } else {
          print('Password not match');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'Failed to sign up: ${e.message}';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print( 'Login success' );
    } on FirebaseAuthException catch (e) {
      // return 'Failed to sign in: ${e.message}';
      print('Failed to sign in: ${e.message}');
      return 'กรุณาตรวจสอบอีเมลและรหัสผ่านอีกครั้ง';

    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Present account selection to the user
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        // Perform sign-in with the selected account
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('Sign in with Google successful');
      } else {
        print('Google sign in canceled');
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signInWithFacebook() async {
   try {
      final fb = FacebookLogin();
      final res = await fb.logIn(permissions: [
        FacebookPermission.email,
        FacebookPermission.publicProfile,
      ]);
      switch (res.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken? accessToken = res.accessToken;
          final AuthCredential credential =
              FacebookAuthProvider.credential(accessToken!.token);
          await FirebaseAuth.instance.signInWithCredential(credential);
          print('Sign in with Facebook successful');
          break;
        case FacebookLoginStatus.cancel:
          print('Facebook sign in canceled');
          break;
        case FacebookLoginStatus.error:
          print('Failed to sign in with Facebook: ${res.error}');
          break;
      }
    } catch (e) {
      print('Failed to sign in with Facebook: $e');
    }
  }

  @override
  Future forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent');
      return 'Password reset email sent';
    } catch (e) {
      print('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
