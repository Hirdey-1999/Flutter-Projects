import 'package:flutter/material.dart';

class chartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPrcnt;

  chartBar(this.label, this.spendingAmount, this.spendingPrcnt);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        children: [
          Container(
            height: 20,
            child:
                FittedBox(child: Text('₹${spendingAmount.toStringAsFixed(0)}')),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            height: constraints.maxHeight * 0.78,
            width: 10,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(5),
                )),
                FractionallySizedBox(
                  heightFactor: spendingPrcnt,
                  child: Container(
                      decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  )),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Container(
              height: constraints.maxHeight * 0.05,
              child: FittedBox(
                  child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ))),
        ],
      );
    }));
  }
}
