import 'package:flutter/material.dart';
import 'package:notewave/note.dart';
import 'package:notewave/note_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';
import 'edit_note_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NoteService _noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    Color _randomColor() {
      return Color.fromRGBO(
        random.nextInt(200),
        random.nextInt(200),
        random.nextInt(200),
        1.0,
      );
    }

    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => EditNoteScreen())));
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: Text('NoteWave'),
            ),
            body: ValueListenableBuilder(
                valueListenable: Hive.box<Note>('noteBox').listenable(),
                builder: (context, Box<Note> box, _) {
                  return GridView.builder(
                      itemCount: box.values.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        var note = box.getAt(index);
                        return GestureDetector(
                          onLongPress: () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    elevation: 4,
                                    child: Container(
                                      width: 50,
                                      height: 100,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(note.title),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
                                              IconButton(
                                                style: ButtonStyle(),
                                                onPressed: (){}, icon: const Icon(Icons.delete,color: Colors.red,))
                                            ],
                                           )
                                          ]),
                                    ),
                                  );
                                });
                          },
                          child: Card(
                            color: _randomColor(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    note!.title,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Text(
                                  note.body,
                                  maxLines: 5,
                                  style: TextStyle(fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                })));
  }
}
