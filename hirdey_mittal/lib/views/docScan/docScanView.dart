import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Document Scanner'),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Original \n Image"),
                Tab(
                  text: "Scan\nImage",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Firstpage(),
              Secondpage(),
            ],
          ),
        ));
  }
}
