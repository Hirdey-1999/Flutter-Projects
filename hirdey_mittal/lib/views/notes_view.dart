import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';
class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}
class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Main UI', textScaleFactor: 1.8,),),
        backgroundColor: Colors.blue,

        actions: [
           PopupMenuButton<MenuAction>(onSelected: (value) async {
             switch (value){
               
               case MenuAction.logout:
                 final shouldLogout = await showLogOutDialog(context);
                 if (shouldLogout){
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                 }
             }
           }, 
           itemBuilder: (context) {
             return const [
               PopupMenuItem<MenuAction>(
                 value: MenuAction.logout , child: Text('Log Out'))];
           },),],
           

      ),
      // drawer: Drawer(child: ListView(children: [TextButton(onPressed: (){}, child: Text('Log OUt'))],),),
      body: Center(
        child: Column(
          children: [
            const Text(' Hello\nHirdey\nMittal', textScaleFactor: 5.9,),
            const Text('Age is 19', textScaleFactor: 2.2,),
            const Text('🙂', textScaleFactor: 2.2,),

          ],
        ),
      ),
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