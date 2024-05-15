import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_project6402262/screen/note.dart';
import 'package:flutter_project6402262/screen/profile.dart';
import 'package:flutter_project6402262/data/note_data.dart';

// ignore: must_be_immutable
class GridDashboard extends StatelessWidget {
  const GridDashboard({super.key});

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Coming Soon"),
          content: const Text("This feature is not available yet."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: NoteRemote().getNoteCount(), // เรียกใช้ฟังก์ชันที่สร้างขึ้นเพื่อรับจำนวนโน้ต
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ถ้ากำลังโหลดข้อมูล
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // หากเกิดข้อผิดพลาดในการโหลดข้อมูล
          return Text('Error: ${snapshot.error}');
        } else {
          // หากโหลดข้อมูลสำเร็จ
          int numberNote = snapshot.data ?? 0; // รับค่าจำนวนโน้ต
          return _buildGridDashboard(context, numberNote); // สร้างส่วนแสดงผล
        }
      },
    );
  }

  Widget _buildGridDashboard(BuildContext context, int numberNote) {
    List<Items> myList = [
      Items(
        title: "Notes",
        subtitle: "Add, Edit, Delete Notes",
        event: "$numberNote Events",
        img: "assets/todo.png",
        navigateTo: const NotePage(),
      ),
      Items(
        title: "Profile",
        subtitle: "Profile Settings",
        event: "",
        img: "assets/setting.png",
        navigateTo: const ProfilePage(),
      ),
      Items(
        title: "Settings",
        subtitle: "General, UI, etc.",
        event: "",
        img: "assets/setting.png",
      ),
      Items(
        title: "Coming soon",
        subtitle: "This feature is not available yet.",
        event: "",
        img: "assets/setting.png",
      ),
    ];

    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: const EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return GestureDetector(
            onTap: () {
              if (data.navigateTo != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => data.navigateTo!),
                );
              } else {
                showComingSoonDialog(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff453658),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width: 42,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.event,
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Widget? navigateTo;

  Items({
    required this.title,
    required this.subtitle,
    required this.event,
    required this.img,
    this.navigateTo,
  });
}
