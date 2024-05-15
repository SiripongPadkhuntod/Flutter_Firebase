import 'package:flutter/material.dart';
import 'package:flutter_project6402262/auth/authpages.dart';
import 'package:flutter_project6402262/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class AuthMain extends StatelessWidget {
  const AuthMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { // Show loading screen while waiting for Firebase to initialize
            return const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            );
          } else if (snapshot.hasError) { // Show error message if error occurs
            return const Center(
              child: Text('Bad Error :('), 
            );
          } else {
            if (snapshot.hasData) { // Check if user is logged in
              return const HomeScreen(); // Show HomeScreen if user is logged in
            } else {
              return const Authpages(); // Show Authpages if user is not logged in
            }
          }
        },
      ),
    );
  }
}
