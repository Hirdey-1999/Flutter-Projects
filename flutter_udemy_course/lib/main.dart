// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_udemy_course/questions.dart';
import 'package:flutter_udemy_course/result.dart';
import 'answer.dart';
import './quiz.dart';

void main() {
  runApp(UdemyApp());
}

class UdemyApp extends StatefulWidget {
  @override
  State<UdemyApp> createState() => _UdemyAppState();
}

class _UdemyAppState extends State<UdemyApp> {
  int questionIndex = 0;
  var totalScore = 0;
  void resetQuiz(){
    setState(() {
    questionIndex = 0;
    totalScore = 0;
    });
  }

  var questions = [
    {
      'questionText': 'What is your favourite color ?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Blue', 'score': 20},
        {'text': 'Red', 'score': 50},
        {'text': 'Green', 'score': 40}
      ]
    },
    {
      'questionText': 'What is your favourite animal ?',
      'answers': [
        {'text': 'Rat', 'score': 20},
        {'text': 'Dog', 'score': 30},
        {'text': 'Cat', 'score': 40},
        {'text': 'Rabbit', 'score': 50}
      ]
    },
    {
      'questionText': 'Which is your Favourite Brand For Electronics',
      'answers': [
        {'text': 'Apple', 'score': 40},
        {'text': 'Samsung', 'score': 50},
        {'text': 'MI', 'score': 10},
        {'text': 'OPPO', 'score': 20}
      ]
    },
  ];
  void answerQuestion(int score) {
    totalScore+=score;
    if (questionIndex < questions.length) {
      setState(() {
        questionIndex = questionIndex + 1;
      });
    } else {
      setState(() {
        questionIndex = 0;
      });
    }
    print(questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: (Text(
              "Hirdey",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )),
          ),
          body: questionIndex < questions.length
              ? quiz(
                  questions: questions,
                  questionIndex: questionIndex,
                  answerQuestion: answerQuestion)
              : result(totalScore, resetQuiz)),
    );
  }
}
