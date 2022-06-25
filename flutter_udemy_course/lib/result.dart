// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class result extends StatelessWidget {
  final int resultScore;
  final  reset ;
  result(this.resultScore, this.reset);

  String get resultPhrase {
    String resultText;
    if (resultScore <= 100) {
      resultText = 'You are awesome and innocent!';
    } else if (resultScore <= 80) {
      resultText = 'Pretty likeable!';
    } else if (resultScore <= 60) {
      resultText = 'You are ... strange?!';
    } else {
      resultText = 'You are so bad!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Center(
            child: Column(
      children: [
        Text(
          resultPhrase,
          style: TextStyle(
            fontSize: 38,
          ),
        ),
        OutlinedButton(onPressed: reset,
        child: Text('Restart'),)
      ],
    )));
  }
}
