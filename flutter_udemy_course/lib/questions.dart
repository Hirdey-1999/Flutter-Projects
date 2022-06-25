import 'package:flutter/material.dart';

class Questions extends StatelessWidget {
  final String questionText;

  Questions(this.questionText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
