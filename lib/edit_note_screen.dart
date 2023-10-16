import 'package:flutter/material.dart';
import 'package:notewave/note.dart';

import 'note_service.dart';

class EditNoteScreen extends StatelessWidget {
  EditNoteScreen({super.key});

  final NoteService _noteService = NoteService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Edit Notes'),
        actions: [
          IconButton(
              onPressed: () {
                var note = Note(
                    body: _bodyController.text, title: _titleController.text);
                _noteService.addNote(note);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    hintText: 'Title', hintStyle: TextStyle(fontSize: 30)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something here..',
                    hintStyle: TextStyle(fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    ));
  }
}