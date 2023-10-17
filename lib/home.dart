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
    final List<Color> backgroundColors = [
      const Color(0xFFE0E0E0), // Lighter Gray
      const Color(0xFFB0C4DE), // Light Steel Blue
      const Color(0xFFFFC0CB), // Pink
      const Color(0xFFD8BFD8), // Thistle
      const Color(0xFFC1FFC1), // Light Green
      const Color(0xFFFFE4B5), // Moccasin
      const Color(0xFFFFFFE0), // Light Yellow
      const Color(0xFFB0E0E6), // Powder Blue
      const Color(0xFFF5E6E6), // Misty Rose
      const Color(0xFFFFF5E6), // Old Lace
    ];

    Color randomColor() {
      final Random random = Random();
      return backgroundColors[random.nextInt(backgroundColors.length)];
    }

    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const EditNoteScreen(
                              appBarTitle: 'Add new note',
                            ))));
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: const Color(0xFF4CAF50),
              title: const Text('NoteWave'),
            ),
            body: ValueListenableBuilder(
                valueListenable: Hive.box<Note>('noteBox').listenable(),
                builder: (context, Box<Note> box, _) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      int crossAixCount =
                          (orientation == Orientation.landscape) ? 3 : 2;
                      return GridView.builder(
                          itemCount: box.values.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAixCount),
                          itemBuilder: (context, index) {
                            var note = box.getAt(index);
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditNoteScreen(
                                            noteObj: note,
                                            index: index,
                                            appBarTitle: 'Edit Note',
                                          ))),
                              onLongPress: () async {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        elevation: 4,
                                        child: SizedBox(
                                          width: 50,
                                          height: 100,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(note.title),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditNoteScreen(
                                                                            noteObj:
                                                                                note,
                                                                            index:
                                                                                index,
                                                                            appBarTitle:
                                                                                'Edit Note',
                                                                          )));
                                                        },
                                                        icon: const Icon(
                                                            Icons.edit)),
                                                    IconButton(
                                                        onPressed: () {
                                                          _noteService
                                                              .deleteNote(
                                                                  index);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                )
                                              ]),
                                        ),
                                      );
                                    });
                              },
                              child: Card(
                                color: randomColor(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        note!.title,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(
                                      note.body,
                                      maxLines: 5,
                                      style: const TextStyle(fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  );
                })));
  }
}
