import 'dart:developer' as devtools show log;
import 'package:hirdey_mittal/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/views/notes_view.dart';
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
      },
    ),
    );
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialise(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user!= null){
              if(user.isEmailVerified) {
                devtools.log('Hello World');
                Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                return const NotesView();
              }
              else{
                return const RegisterView();
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