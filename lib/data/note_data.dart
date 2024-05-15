import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



abstract class NoteData {
  Future<void> addData(String title, String category);
  Future<void> updateData(String title, String description, String id, String category);
  Future<void> deleteData(String id);
  Future<List<Map<String, dynamic>>> listData();
  Future<List<String>> fetchCategories();
  

}


class NoteRemote implements NoteData {
  final col = 'users';

  @override
  Future<void> addData(String title,String category) async {
    if(category == '') category = '!';
    else category = category;
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;
      
      await FirebaseFirestore.instance.collection(col).doc(uid).collection('user_notes').add({
        'title': title,
        'date': DateTime.now(),
        'category': category,
      });
      print('Add data success');
    } catch (e) {
      print('Failed to add data: $e');
    } 
  }

  @override
  Future<void> updateData(String title, String description, String id,String category) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    if(description == '') description = '';
    else description = description;
    await FirebaseFirestore.instance.collection(col).doc(uid).collection('user_notes').doc(id).update({
      'title': title,
      'description': description,
      'category': category,
      'Edited': DateTime.now(),
    });
    print('Update data success');
  }

  @override
  Future<void> deleteData(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    await FirebaseFirestore.instance.collection(col).doc(uid).collection('user_notes').doc(id).delete();
    print('Delete data success');
  }

  @override
  Future<List<Map<String, dynamic>>> listData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final snapshot = await FirebaseFirestore.instance.collection(col).doc(uid).collection('user_notes').get();
    List<Map<String, dynamic>> notesList = [];
    for (var doc in snapshot.docs) {
      final id = doc.id; // เก็บ ID ของโน้ต
      final data = doc.data();
      data['id'] = id; // เพิ่ม ID ลงในข้อมูลของโน้ต
      data['date'] = (data['date'] as Timestamp).toDate(); 
      notesList.add(data);
    }
    return notesList;
  }

  @override
  Future<List<String>> fetchCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final snapshot = await FirebaseFirestore.instance.collection(col).doc(uid).collection('user_notes').get();
    List<String> categories = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (!categories.contains(data['category'])) {
        categories.add(data['category']);
      }
    }
    return categories;
  }

  Future<int> getNoteCount() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final snapshot = await FirebaseFirestore.instance.collection(col).doc(uid).collection('user_notes').get();
    return snapshot.docs.length;
  }



}
