import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/service/crud/notes_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/logout-dialog.dart';
import 'package:hirdey_mittal/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}
class _NotesViewState extends State<NotesView> {
  late final noteService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    
    _notesService = noteService();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', textScaleFactor: 1.8,),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {Navigator.of(context).pushNamed(newNoteRoute);} , icon: const Icon(Icons.add)),
          //LogOut
          IconButton(onPressed: () async{ final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout){
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
            } }, icon: Icon( Icons.logout,),),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context,snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            return StreamBuilder(stream: _notesService.allNotes,builder: (context,snapshot){
              switch (snapshot.connectionState){
                case ConnectionState.active:
                case ConnectionState.waiting:
                  if(snapshot.hasData){
                    final allNotes = snapshot.data as List<DatabaseNotes>;
                    return notesListView(notes: allNotes, onDeleteNote: (note) async {
                      await _notesService.deleteNote(id: note.id);
                    });
                    print(allNotes);
                    
                  }else{
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
            } } ) ;
            default:
              return const CircularProgressIndicator();
          }
        }
      )

    );
  }
}
