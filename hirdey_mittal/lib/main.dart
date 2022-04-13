// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    ),
    );
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Home Page'))),
      body: FutureBuilder(
         future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
            ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if(user?.emailVerified??false){
              print('You Are A verified user');
            }
            else {
              print('OOPS! You Are Not Verified');
            }
            return const Text('Done');
        default: 
        return Text("Loading....");}
          
        }
      )
    );
  }
}
