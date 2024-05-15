// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_project6402262/data/user_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? selectedDate;
  String? _imageURL; // เปลี่ยนจาก File เป็น String เพื่อเก็บ URL ของรูปภาพ
  File? _image;

  @override
  void initState() {
    super.initState();
    _username();
  }

  void _username() async {
    Map<String, dynamic> profileData = await UserRemote().fetchProfile();
    if (profileData.isNotEmpty) {
      String? name = profileData['name'];
      String? phone = profileData['phone'];
      String? birthDate = profileData['birthDate'];
      _imageURL = profileData['img']; // เก็บ URL ของรูปภาพจากฐานข้อมูล
      print('Image URL: $_imageURL');

      setState(() {
        nameController.text = name ?? '';
        phoneController.text = phone ?? '';

        if (birthDate != null && birthDate.isNotEmpty) {
          try {
            selectedDate = DateTime.parse(birthDate);
          } catch (e) {
            print('Error parsing birthDate: $e');
          }
        } else {
          selectedDate = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _showExitConfirmationDialog(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _imageURL != null
                          ? NetworkImage(_imageURL!)
                          : null, // ใช้ NetworkImage เพื่อแสดงรูปภาพจาก URL
                      child: _imageURL == null
                          ? const Icon(Icons.person)
                          : null, // แสดงไอคอนที่กำหนดหากไม่มี URL ให้กับรูปภาพ
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 243, 72),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            _pickImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              FullName(),
              const SizedBox(height: 20),
              PhoneNumber(),
              const SizedBox(height: 20),
              b_date(context),
              const SizedBox(height: 50),
              btnSave(context),
            ],
          ),
        ),
      ),
    );
  }

  TextField PhoneNumber() {
    return TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
            );
  }

  TextField FullName() {
    return TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            );
  }

  ElevatedButton btnSave(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            selectedDate != null) {
          UserRemote().updateData(
            nameController.text,
            phoneController.text,
            selectedDate.toString(),
          );
          // เพิ่มการอัปโหลดรูปภาพที่ถูกเลือก
          if (_image != null) {
            try {
              UserRemote().uploadImage(_image!);
            } on Exception catch (e) {
              print('Error uploading image: $e');
            }
          }
          savesuccess(context);
        } else {
          _showEditConfirmationDialog(context);
        }
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 255, 243, 72)),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: const Text(
        'Save',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  TextField b_date(BuildContext context) {
    return TextField(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Birth Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      controller: TextEditingController(
        text: selectedDate == null
            ? ''
            : '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Changes?"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("คณต้องการออกจากหน้า Profile หรือไม่?"),
              Text("กรุณาบันทึกข้อมูลก่อนออกจากหน้านี้"),
              Text("หากไม่บันทึกข้อมูลจะสูญหาย"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imageURL = null; // ลบ URL ของรูปภาพเดิมออก
      });
    }
  }

  void savesuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Success"),
          content: const Text("Your profile has been updated."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _username();
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showEditConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Data"),
          content:
              const Text("Please fill in all fields before saving changes."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
