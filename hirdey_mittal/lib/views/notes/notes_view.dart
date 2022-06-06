import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/service/cloud/cloud_note.dart';
import 'package:hirdey_mittal/service/crud/notes_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/logout-dialog.dart';
import 'package:hirdey_mittal/views/docScan/docScanView.dart';
import 'package:hirdey_mittal/views/notes/create-update-notes-view.dart';
import 'package:hirdey_mittal/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../service/cloud/firebase_cloud_storage.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notes',
            textScaleFactor: 1.8,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateNotesRoutes);
                },
                icon: const Icon(Icons.add)),
            //LogOut
            IconButton(
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
              title: const Text('Notes'),
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              },
            ),
            ListTile(
              title: const Text('DocScan'),
              onTap: () {
                Navigator.of(context).pushNamed(docScanRoutes);
              },),
          ],
        )),
        body: StreamBuilder(
            stream: _notesService.allNotes(ownerUserID: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    return notesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                            documentID: note.documentID);
                      },
                      onTap: (note) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNotesRoutes,
                          arguments: note,
                        );
                      },
                    );
                    print(allNotes);
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
