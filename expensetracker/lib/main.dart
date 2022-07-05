import 'dart:io';
import 'package:expensetracker/widgets/chart.dart';
import 'package:expensetracker/widgets/transaction_list.dart';
import 'package:expensetracker/widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(expenseApp());
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class expenseApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracking',
      home: MyApp(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.greenAccent,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
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
    Transaction(
      id: 't3',
      title: 'Grocery',
      amount: 100000,
      date: DateTime.parse("2022-06-26"),
    ),
  ];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
    String txTitle,
    double txAmount,
    DateTime selectedDate,
  ) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
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

  void deleteTransactions(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandscape)Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Chart View',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Switch.adaptive(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),
            if(!isLandscape)Container(
                    height: (MediaQuery.of(context).size.height -
                            AppBar.preferredHeightFor(
                                context, Size.fromHeight(50)) -
                            MediaQuery.of(context).padding.top) *
                        0.3,
                    child: chartWidget(_recentTransactions)),
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            AppBar.preferredHeightFor(
                                context, Size.fromHeight(50)) -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: chartWidget(_recentTransactions))
                : Card(
                    child: Container(
                      height: 50,
                      child: Text(
                        'Last Transactions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    elevation: 5,
                  ),
            Container(
                height: (MediaQuery.of(context).size.height -
                        AppBar.preferredHeightFor(
                            context, Size.fromHeight(50)) -
                        MediaQuery.of(context).padding.top) *
                    0.6,
                child: transactionList(_userTransactions, deleteTransactions))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showTransactions(context),
      ),
    );
  }
}
