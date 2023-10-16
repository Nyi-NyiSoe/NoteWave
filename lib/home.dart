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
      Color(0xFFE0E0E0), // Lighter Gray
      Color(0xFFB0C4DE), // Light Steel Blue
      Color(0xFFFFC0CB), // Pink
      Color(0xFFD8BFD8), // Thistle
      Color(0xFFC1FFC1), // Light Green
      Color(0xFFFFE4B5), // Moccasin
      Color(0xFFFFFFE0), // Light Yellow
      Color(0xFFB0E0E6), // Powder Blue
      Color(0xFFF5E6E6), // Misty Rose
      Color(0xFFFFF5E6), // Old Lace
    ];

    Color _randomColor() {
      final Random random = Random();
      return backgroundColors[random.nextInt(backgroundColors.length)];
    }

    bool isLargeScreen() {
      if (MediaQuery.of(context).size.width > 600) {
        return true;
      } else {
        return false;
      }
    }

    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => EditNoteScreen(
                              appBarTitle: 'Add new note',
                            ))));
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: Color(0xFF4CAF50),
              title: Text('NoteWave'),
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
                                        child: Container(
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
                                                        style: ButtonStyle(),
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
                                color: _randomColor(),
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
