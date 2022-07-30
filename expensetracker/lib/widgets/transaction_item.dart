

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class transactionItem extends StatelessWidget {
  const transactionItem({
    Key? key,
    required this.transaction,
    required this.txdelete,
  }) : super(key: key);

  final Transaction transaction;
  final  txdelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      elevation: 3,
      child: ListTile(
        leading: FittedBox(
            child: CircleAvatar(
          radius: 40,
          child: Text(transaction.amount.toString()),
        )),
        title: Text(transaction.title),
        subtitle: Text(
            DateFormat.yMMMd().format(transaction.date)),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                onPressed: () => txdelete(transaction.id),
                icon: const Icon(Icons.delete,),
                label: const Text('Delete'))
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => txdelete(transaction.id),
                color: Colors.red,
              ),
      ),
    );
  }
}
