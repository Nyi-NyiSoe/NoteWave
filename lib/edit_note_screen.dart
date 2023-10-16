import 'package:flutter/material.dart';
import 'package:notewave/note.dart';

import 'note_service.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? noteObj;
  final int? index;
  EditNoteScreen({Key? key, this.noteObj, this.index});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final NoteService _noteService = NoteService();

  TextEditingController _titleController = TextEditingController();

  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.noteObj != null) {
      _titleController = TextEditingController(text: widget.noteObj!.title);
      _bodyController = TextEditingController(text: widget.noteObj!.body);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Edit Notes'),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.noteObj != null) {
                  _noteService.updateNote(widget.index!, _titleController.text,
                      _bodyController.text);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Saved')));
                } else {
                  var note = Note(
                      body: _bodyController.text, title: _titleController.text);
                  _noteService.addNote(note);
                   ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Added new')));
                }
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
