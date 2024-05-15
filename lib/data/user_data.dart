// ignore_for_file: avoid_print
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class UserData {
  Future<void> addDataNew();
  Future<void> updateData(String name, String phone, String birthDate);
  Future<void> deleteData();
  Future<void> fetchData();
  Future<Map<String, dynamic>> fetchProfile();
  Future<void> uploadImage(File image);
}

class UserRemote implements UserData {

  @override
  Future<void> addDataNew() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        await docRef.set({
          'name': 'Set Your Name',
          'phone': '',
          'birthDate': '',
          'img': 'https://firebasestorage.googleapis.com/v0/b/flutter-e05d8.appspot.com/o/1000000035.jpg?alt=media&token=05fdc0ad-0621-4130-9082-bcfccade7939',
        });
        print('Add data success');
      } else {
        print('Document already exists');
        // จัดการกับกรณีที่เอกสารมีอยู่ใน Firestore ตามที่เหมาะสม
      }
    } else {
      print('User is not signed in');
      // จัดการกับกรณีที่ผู้ใช้ไม่ได้เข้าสู่ระบบ ตามที่เหมาะสม
    }
  }


  @override
  Future<void> updateData(String name, String phone, String birthDate) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // ตรวจสอบว่ามีเอกสารนี้อยู่ใน Firestore หรือไม่
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.update({
          'name': name,
          'phone': phone,
          'birthDate': birthDate,
        });
        print('Update data success');
      } else {
        print('Document does not exist');
        // จัดการกับกรณีที่เอกสารไม่มีอยู่ใน Firestore ตามที่เหมาะสม
      }
    } else {
      print('User is not signed in');
      // จัดการกับกรณีที่ผู้ใช้ไม่ได้เข้าสู่ระบบ ตามที่เหมาะสม
    }
  }

  @override
  Future<void> deleteData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    print('Delete data success');
  }

  @override
  Future fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snapshot.data()?['name'];
    } else {
      return "Username"; // หรือทำการจัดการผลลัพธ์อื่น ๆ ตามที่เหมาะสม
    }
  }

  @override
  Future<Map<String, dynamic>> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snapshot.data() ?? {}; // คืนค่าเป็น Map ว่างถ้าไม่พบข้อมูล
  }

  @override
  Future<void> uploadImage(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;
      final fileName = basename(image.path);
      final storageRef = FirebaseStorage.instance.ref().child('img').child(uid).child(fileName);
      await storageRef.putFile(image);
      final url = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'img': url,
      });
    } on Exception catch (e) {
      print('Failed to upload image: $e');
    }
  }
}
