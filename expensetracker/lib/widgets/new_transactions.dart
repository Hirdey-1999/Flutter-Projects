import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class newTransaction extends StatefulWidget {
  final addTx;
  newTransaction(this.addTx);

  @override
  State<newTransaction> createState() => _newTransactionState();
}

class _newTransactionState extends State<newTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
    );

    Navigator.of(context).pop;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Your New Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      onPressed: Navigator.of(context).pop,
                      icon: Icon(
                        Icons.close,
                        size: 30,
                      )),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextButton(
                onPressed: () => widget.addTx(
                    titleController.text, double.parse(amountController.text)),
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
