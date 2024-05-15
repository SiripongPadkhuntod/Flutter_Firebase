import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project6402262/data/note_data.dart';
import 'package:flutter_project6402262/screen/notedetail.dart';


class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  List<Map<String, dynamic>> _notes = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadNotes();
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


  Widget _buildNotesList() {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        if (_selectedCategory == null || _notes[index]['category'] == _selectedCategory) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _notes[index]['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _notes[index]['date'] != null
                        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(_notes[index]['date'].toString()))
                        : '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Category: ${_notes[index]['category']}',
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
                          builder: (context) => NoteDetailPage(note: _notes[index]),
                        ),
                      );
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
                            content: const Text('Are you sure you want to delete this note?'),
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
        title: const Text('Note'),
        backgroundColor: const Color.fromARGB(255, 122, 154, 230),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotes,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<String>>(
              future: NoteRemote().fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String>? categories = snapshot.data;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        for (String category in categories!)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: const TextStyle(fontSize: 16),
                              ),
                              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                              selected: _selectedCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = selected ? category : null;
                                });
                              },
                              selectedColor: Colors.blue[200],
                              backgroundColor: Colors.blue[100],
                              checkmarkColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
