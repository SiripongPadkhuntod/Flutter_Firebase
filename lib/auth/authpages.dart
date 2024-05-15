// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project6402262/screen/signup.dart';
import 'package:flutter_project6402262/screen/login.dart';

class Authpages extends StatefulWidget {
  const Authpages({super.key});

  @override
  State<Authpages> createState() => _AuthpagesState();
}

class _AuthpagesState extends State<Authpages> {
  
  bool isLogin = true;
  void toggleAuth() {
    setState(() {
      isLogin = !isLogin;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginScreen(toggleAuth);
    } else {
      return SignupScreen(toggleAuth);
    }
  }
}
