import 'package:flutter/material.dart';

class home_page extends StatelessWidget {
  var name = "and You Are My Friend";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("What Is Your Name"),
      ),
      body: Material(
        child: Center(
          child: Container(
            child: Text("Hi! Myself Hirdey Mittal $name"),
          ),
        ),
      ),
      drawer: Drawer(),
    );
  }
}
