import 'package:flutter/material.dart';
import 'package:flutter_project6402262/data/auth_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_project6402262/data/user_data.dart';
import 'griddashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _user = 'Example User';

  @override
  void initState() {
    super.initState();
    _username();
  }

  void _username() async {
    String? user = await UserRemote().fetchData();
    if (user != null) {
      setState(() {
        _user = user;
      });
    } else {
      setState(() {
        _user = 'Set Your Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff392850),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hi ! $_user",
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Welcome back  : )",
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Color(0xffa29aac),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    await AuthRemote().signOut();
                    setState(() {
                      _user = 'Set Your Name';
                    });
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const GridDashboard(),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _username();
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
