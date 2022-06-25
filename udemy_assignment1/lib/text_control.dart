import 'package:flutter/material.dart';

class textControl extends StatelessWidget {
  final queN;
  final lines;
  final click;
  final reset;
  textControl({this.queN,this.lines,this.click, this.reset});
  @override
  Widget build(BuildContext context) {
    return queN<lines.length ? Column(
        children: [
          Center(child: Text(lines[queN],style: TextStyle(fontSize: 38),)),
          OutlinedButton(onPressed: click, child: Text('Change The Line'))
        ],
      ) : Column(
        children: [
          Text('WE ARE FINISHED'),
          RaisedButton(onPressed: reset, child: Text('Reset'),)
        ],
      ) ;
  }
}