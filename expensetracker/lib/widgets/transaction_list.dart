import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'transaction_item.dart';

class transactionList extends StatelessWidget {
  final List<Transaction> Transactions;
  final txdelete;
  const transactionList(this.Transactions, this.txdelete);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: Transactions.isEmpty
          ? LayoutBuilder(builder: ((ctx, constraints) {
              return Column(children: [
                const Text(
                  'No Transactions Added Yet !!',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover)),
              ]);
            }))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return transactionItem(transaction: Transactions[index], txdelete: txdelete);
              },
              itemCount: Transactions.length,
            ),
    );
  }
}

