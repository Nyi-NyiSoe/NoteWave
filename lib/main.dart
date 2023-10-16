import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notewave/note.dart';
import 'package:notewave/note_service.dart';
import 'home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final NoteService _noteService = NoteService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: _noteService.getAllNotes(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Note>> snapshot){

              if (snapshot.connectionState == ConnectionState.done) {
                return HomePage();
              } else {
               return const CircularProgressIndicator();
              }
              
            }));
  }
}
