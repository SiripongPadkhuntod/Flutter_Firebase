import 'package:flutter/material.dart';
import 'package:flutter_project6402262/data/auth_data.dart';
import 'package:flutter_project6402262/pallete.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback toggleAuth;

  const SignupScreen(this.toggleAuth, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

   void _submitSignUp() {
    if (_formKey.currentState!.validate()) {
      AuthRemote().signUp(
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
      ).then((message) {
        if (message != null) {
          // Show dialog if message is not null
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sign Up Error'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView to avoid overflow
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                title(),
                SizedBox(height: size.height * 0.03),
                email(),
                password(),
                conpassword(),
                SizedBox(height: size.height * 0.03),
                btnsignup(size),
                SizedBox(height: size.height * 0.03),
                gosignin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container gosignin() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextButton(
        onPressed: () {
          widget.toggleAuth();
        },
        child: const Text(
          'Do you have an account? Sign in here.',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container btnsignup(Size size) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          _submitSignUp();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          width: size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 41, 3),
                Color.fromARGB(255, 243, 136, 36),
              ],
            ),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Container conpassword() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: confirmPasswordController,
        decoration: const InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: 'Confirm Password',
          hintText: 'Enter your password again',
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          } else if (value != passwordController.text) {
            return 'Passwords do not match';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Container password() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: 'Password',
          hintText: 'Enter your password',
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            color: _isPasswordVisible ? Colors.blue : Colors.grey,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
        
        ),
        style: const TextStyle(color: Colors.white), // กำหนดสีข้อความที่พิมพ์ในฟิลด์
        obscureText: !_isPasswordVisible,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else if (value.length < 6) {
            return 'Password must be at least 6 characters';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Container email() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          prefixIcon: const Icon(Icons.email),
          labelText: 'Email',
          hintText: 'Enter your email',
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          } else if (!value.contains('@')) {
            return 'Please enter valid email';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Container title() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: const Text(
        'Create Account',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 36),
        textAlign: TextAlign.left,
      ),
    );
  }
}
