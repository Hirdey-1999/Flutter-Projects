import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class answerWidget extends StatelessWidget {
  final selection;
  final String options;
  
  answerWidget(this.selection ,this.options);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: selection,
        child: Text(options),
        style: 
              OutlinedButton.styleFrom(primary: Colors.black,side: BorderSide(color: Colors.black)),
            
      ),
    );
  }
}
