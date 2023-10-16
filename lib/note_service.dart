import 'package:hive/hive.dart';
import 'package:notewave/note.dart';

class NoteService {
  final String _boxName = "noteBox";
  Future<Box<Note>> get _box async => await Hive.openBox<Note>(_boxName);

  Future<void> addNote(Note note) async {
    var box = await _box;
    box.add(note);
  }

  Future<List<Note>> getAllNotes() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteNote(int index) async {
    var box = await _box;
    box.deleteAt(index);
  }

  Future<void> updateNote(int index, String title, String body) async {
    var box = await _box;

    box.putAt(index, Note(body: body, title: title));
   
  }
  
}
