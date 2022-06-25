import 'package:expensetracker/widgets/transaction_list.dart';
import 'package:expensetracker/widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transactions.dart';

void main() => runApp(expenseApp());

class expenseApp extends StatelessWidget {
  Widget build (BuildContext context){
    return MaterialApp(
      title: 'Expense Tracking',
      home: MyApp(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.greenAccent,
        appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'Quicksand', fontSize: 25, fontWeight: FontWeight.bold)) 

      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Laptop',
      amount: 50000,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Grocery',
      amount: 1000,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void showTransactions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return newTransaction(_addNewTransaction);
        });
  }
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracking'),
          elevation: 8,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
                onPressed: () => showTransactions(context),
                ),
            IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  child: Text(
                    'CHARTS',
                  ),
                  elevation: 50,
                ),
                width: double.maxFinite,
                height: 200,
              ),
              SizedBox(height: 50,),
              transactionList(_userTransactions)
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showTransactions(context),
          
        ),
    );
  }
}
