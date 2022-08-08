import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hirdey_mittal/service/cloud/cloud_note.dart';
import 'package:hirdey_mittal/service/crud/notes_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class notesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const notesListView(
      {Key? key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          // return Card(
          //   color: Colors.accents[Random().nextInt(Colors.accents.length)],
          //   margin: EdgeInsets.all(10),
          //   elevation: 10,

          //   child: ListTile(
          //       onTap: () {
          //         onTap(note);
          //       },
          //       title: Text(
          //         note.text,
          //         maxLines: 5,
          //         softWrap: true,
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //       trailing: IconButton(
          //         onPressed: () async {
          //           final shouldDelete = await showDeleteDialog(context);
          //           if (shouldDelete) {
          //             onDeleteNote(note);
          //           }
          //         },
          //         icon: const Icon(Icons.delete),
          //       )),
          // );
          return Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 2,
              bottom: 5
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  // color:
                  //     Colors.accents[Random().nextInt(Colors.accents.length)],
                  decoration: BoxDecoration(
                      color: Colors.accents[Random().nextInt(Colors.accents.length)],
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final shouldDelete = await showDeleteDialog(context);
                      if (shouldDelete) {
                        onDeleteNote(note);
                      }
                    },
                  ),
                ),
                Container(
                  height: 155,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(249, 255, 146,100),
                      borderRadius: BorderRadius.only(
                        bottomLeft:  Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  child: ListTile(
                    onTap: () {
                      onTap(note);
                    },
                    title: Text(
                      note.text,
                      maxLines: 5,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
