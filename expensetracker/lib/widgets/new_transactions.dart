import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class newTransaction extends StatefulWidget {
  final addTx;
  newTransaction(this.addTx);

  @override
  State<newTransaction> createState() => _newTransactionState();
}

class _newTransactionState extends State<newTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    final date = selectedDate;

    if (enteredTitle.isEmpty || enteredAmount <= 0 || date == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      date,
    );

    Navigator.of(context).pop;
  }

  void presentDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1962),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   const  Text(
                      'Add Your New Transaction',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: const Icon(
                          CupertinoIcons.clear,
                          size: 28,
                        )),
                  ],
                ),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
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
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date Is:  ${DateFormat.yMMMd().format(selectedDate)}'),
                    IconButton(
                      onPressed: presentDate,
                      icon: Icon(CupertinoIcons.calendar),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: 500,
                child: CupertinoButton(
                  child: const Text('Add Transaction',style: TextStyle(fontSize: 20),),
                  color: Colors.teal,
                  onPressed: () => widget.addTx(titleController.text,
                      double.parse(amountController.text), selectedDate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
