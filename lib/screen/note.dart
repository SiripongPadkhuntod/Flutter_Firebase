import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project6402262/data/note_data.dart';
import 'package:flutter_project6402262/screen/notedetail.dart';
import 'package:flutter_project6402262/data/user_data.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String _user = 'Test';
  List<Map<String, dynamic>> _notes = [];
  String? _selectedCategory;
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _username();
  }

  void _loadNotes() async {
    List<Map<String, dynamic>> notes = await NoteRemote().listData();
    notes.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));
    setState(() {
      _notes = notes;
    });
    _titleController.clear();
    _categoryController.clear();
  }

  void _username() async {
    Map<String, dynamic> profileData = await UserRemote().fetchProfile();
    if (profileData.isNotEmpty) {
      String? name = profileData['name'];
      _imageURL = profileData['img']; // เก็บ URL ของรูปภาพจากฐานข้อมูล
      setState(() {
        _user = name ?? '';
      });
    }
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a note'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter your note title',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  hintText: 'Enter category',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = _titleController.text;
                String category = _categoryController.text;
                if (title.isNotEmpty) {
                  setState(() {
                    _notes.add({
                      'title': title,
                      'category': category,
                    });
                  });
                  NoteRemote().addData(title, category);
                }
                _loadNotes();
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 0, 6),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x4D9489F5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6F61EF),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  _imageURL ?? 'https://via.placeholder.com/150',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _user.toString(),
          style: const TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF15161E),
            fontSize: 24,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: Color(0xFF15161E),
                size: 24,
              ),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            categoriesWidget(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildNotesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNote,
        label: const Text(
          'Add Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green, // เปลี่ยนสีปุ่มเพิ่ม Note เป็นสีเขียว
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }


  Widget _buildNotesList() {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        if (_selectedCategory == null || _notes[index]['category'] == _selectedCategory) {
          String title = _notes[index]['title'];
          if (title.split('\n').length > 2) {title = '${title.split('\n').sublist(0, 2).join('\n')}...';}
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // จำกัดจำนวนบรรทัดสูงสุดเป็น 3 บรรทัด
                    overflow: TextOverflow
                        .ellipsis, // ให้ข้อความที่เกินขอบเขตแสดง ...
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _notes[index]['date'] != null
                        ? DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(_notes[index]['date'].toString()))
                        : '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                '${_notes[index]['category']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoteDetailPage(note: _notes[index]),
                        ),
                      ).then((value) {
                        _loadNotes();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete note'),
                            content: const Text(
                                'Are you sure you want to delete this note?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  NoteRemote().deleteData(_notes[index]['id']);
                                  _loadNotes();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget categoriesWidget() {
    return FutureBuilder<List<String>>(
      future: NoteRemote().fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 4, 84, 150),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String>? categories = snapshot.data;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: categories!.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                    selectedColor: const Color.fromARGB(255, 140, 248, 230),
                    backgroundColor: const Color.fromARGB(255, 147, 206, 255),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4, // เพิ่มเงา
                    shadowColor: Colors.black, // สีเงา
                    pressElevation: 6, // เงาเมื่อกด
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }


}
