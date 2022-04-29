import 'dart:developer' as devtools show log;
import 'package:hirdey_mittal/constants/routes.dart';

import 'views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        '/verifyemail/':(context) => const verifyEmailView(),
      },
    ),
    );
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return FutureBuilder(
         future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
            ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user!= null){
              if(user.emailVerified) {
                devtools.log('Hello World');
                Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                return const NotesView();
              }
              else{
                return const verifyEmailView();
              }
            } else {
              return const LoginView();
            }
            
        default: 
        return const CircularProgressIndicator();}
          
        }
      );
  }
}
enum MenuAction { logout }
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
                  await FirebaseAuth.instance.signOut();
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