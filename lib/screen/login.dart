// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_project6402262/data/auth_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_project6402262/pallete.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleAuth;

  const LoginScreen(this.toggleAuth, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailforgotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  Future<void> _submitSignIn() async {
    if (_formKey.currentState!.validate()) {
      AuthRemote().signIn(
        emailController.text,
        passwordController.text,
      ).then((message) {
        if (message != null) {
          // Show dialog if message is not null
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('ไม่สามารถเข้าสู่ระบบได้ :['),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
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
    emailforgotController.dispose();
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
                subtitle(),
                SizedBox(height: size.height * 0.03),
                buildEmailTextField(),
                const SizedBox(height: 10),
                buildPasswordTextField(),
                SizedBox(height: size.height * 0.01),
                forgot(context, emailforgotController),
                SizedBox(height: size.height * 0.03),
                btnlogin(size),
                SizedBox(height: size.height * 0.03),
                gotosignup(widget: widget),
                SizedBox(height: size.height * 0.03),
                const OR(),
                SizedBox(height: size.height * 0.03),
                const signgoogle(),
                const signfacebook(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container btnlogin(Size size) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty) {
              _submitSignIn();
            }
          }
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
            'Sign in',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: const Icon(Icons.email),
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
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

  Widget buildPasswordTextField() {
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
}

class OR extends StatelessWidget {
  const OR({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Divider(
                color: Color.fromARGB(255, 255, 255, 255),
                height: 36,
              ),
            ),
          ),
          const Text(
            'OR',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Divider(
                color: Color.fromARGB(255, 255, 255, 255),
                height: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class signfacebook extends StatelessWidget {
  const signfacebook({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: ElevatedButton.icon(
        onPressed: () async {
          // AuthRemote().signInWithFacebook();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Coming soon!'),
                content: const Text('This feature is coming soon.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Continue with Facebook',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101213),
            ),
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.facebook,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(230, 44),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: const BorderSide(
              color: Color(0xFFE0E3E7),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class signgoogle extends StatelessWidget {
  const signgoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: ElevatedButton.icon(
        onPressed: () async {
          AuthRemote().signInWithGoogle();
        },
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Continue with Google',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101213),
            ),
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.google,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(230, 44),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: const BorderSide(
              color: Color(0xFFE0E3E7),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class gotosignup extends StatelessWidget {
  const gotosignup({
    super.key,
    required this.widget,
  });

  final LoginScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () {
            widget.toggleAuth();
          },
          child: const Text(
            'Don\'t have an account? Sign up',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Widget forgot(
    BuildContext context, TextEditingController emailforgotController) {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: TextButton(
      onPressed: () {
        showDialog(
          // Show dialog for forgot password
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Forgot Password'),
              content: TextField(
                
                controller: emailforgotController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AuthRemote().forgotPassword(emailforgotController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
      child: const Text(
        'Forgot your password?',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
  );
}

Widget subtitle() {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: const Text(
      'Login to your account',
      style: TextStyle(color: Colors.blue, fontSize: 16),
      textAlign: TextAlign.left,
    ),
  );
}

Widget title() {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: const Text(
      'Welcome Back :]',
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 36),
      textAlign: TextAlign.left,
    ),
  );
}
