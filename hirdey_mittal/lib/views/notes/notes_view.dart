import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/service/crud/notes_service.dart';

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
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Notes', textScaleFactor: 1.8,),),
        backgroundColor: Colors.blue,
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
                case ConnectionState.waiting:
                  return const Text('Waiting For All Notes Wait For A Seconds....');
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

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are You Sure You Want To Log Out?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: const Text('Log Out'),),
        ],
      );
  },
  ).then((value) => value ?? false);
}