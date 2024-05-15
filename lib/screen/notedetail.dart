import 'package:flutter/material.dart';
import 'package:flutter_project6402262/data/note_data.dart';
import 'package:intl/intl.dart';

class NoteDetailPage extends StatelessWidget {
  final Map<String, dynamic> note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: note['title']);
    TextEditingController categoryController =
        TextEditingController(text: note['category']);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF536DFE), Color(0xFF5C6BC0)],
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Note Details',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Update note in the database
                if (titleController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  // If title or category is empty, show a snackbar message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  if (note['description'] == null) note['description'] = '';
                  NoteRemote().updateData(
                    titleController.text, // Updated title
                    note['description'], // Current description
                    note['id'], // Note ID
                    categoryController.text, // Updated category
                  );
                  // Show a snackbar message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note updated'),
                      backgroundColor: Colors.greenAccent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              onChanged: (value) {
                // Update title in the note object
                note['title'] = value;
              },
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'หัวข้อ',
                labelStyle: const TextStyle(
                  color: Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: categoryController,
              onChanged: (value) {
                // Update category in the note object
                note['category'] = value;
              },
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'หมวดหมู่',
                labelStyle: const TextStyle(
                  color: Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'แก้ไขล่าสุด : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: note['description']),
                onChanged: (value) {
                  // Update description in the note object
                  note['description'] = value;
                },
                maxLines: null,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'รายละเอียด',
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
