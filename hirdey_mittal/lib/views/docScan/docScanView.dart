import 'package:flutter/material.dart';
import 'package:hirdey_mittal/constants/routes.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/logout-dialog.dart';
import 'package:hirdey_mittal/views/docScan/docScan_Screens/FirstScreen.dart';
import 'package:hirdey_mittal/views/docScan/docScan_Screens/SecondScreen.dart';

class docScanView extends StatefulWidget {
  const docScanView({Key? key}) : super(key: key);

  @override
  State<docScanView> createState() => _docScanViewState();
}

class _docScanViewState extends State<docScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    String emailId = AuthService.firebase().currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner'),
        backgroundColor: Colors.blue,
        actions: [
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
                    'Hey!, $emailId',
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
      body: Firstpage()
    );
  }
}
