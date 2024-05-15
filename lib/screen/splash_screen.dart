import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_project6402262/auth/main_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthMain()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/4.png', // ตำแหน่งของไฟล์ใน assets ของคุณ
              width: 300, // ขนาดของรูปภาพ
              height: 300,
            ),
            const SizedBox(height: 15), // ระยะห่างระหว่างรูปภาพกับข้อความ
            const Text(
              'LifeNoteBooking',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
