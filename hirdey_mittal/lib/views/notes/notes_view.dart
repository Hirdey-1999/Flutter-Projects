import 'package:firebase_auth/firebase_auth.dart';
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
  String get emailId => AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(100),
            ),
          ),
          bottom: PreferredSize(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text('What is Your Today\'s Notes ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w300,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(100)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateNotesRoutes);
                },
                icon: const Icon(Icons.add,color: Colors.white,)),
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
                Icons.logout,color: Colors.white
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500),side: BorderSide.none),
            child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                height: 60,
                child: ListTile(
                    leading: Card(
                      child: Icon(Icons.person, size: 40),
                      elevation: 5,
                    ),
                    title: Text(
                      'Hey!, ' + emailId,
                      style: TextStyle(color: Colors.white),
                    )),
                color: Colors.blue,
              ),
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
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(docScanRoutes, (route) => false);
                },
              ),
            ],
          ),
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
