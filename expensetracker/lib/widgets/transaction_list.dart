import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class transactionList extends StatelessWidget {
  final List<Transaction> Transactions;
  final txdelete;
  transactionList(this.Transactions, this.txdelete);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: Transactions.isEmpty
          ? LayoutBuilder(builder: ((ctx, constraints) {
              return Column(children: [
                Text(
                  'No Transactions Added Yet !!',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
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
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                  elevation: 3,
                  child: ListTile(
                    leading: FittedBox(
                        child: CircleAvatar(
                      radius: 40,
                      child: Text(Transactions[index].amount.toString()),
                    )),
                    title: Text(Transactions[index].title),
                    subtitle: Text(
                        DateFormat.yMMMd().format(Transactions[index].date)),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            onPressed: () => txdelete(Transactions[index].id),
                            icon: Icon(Icons.delete,),
                            label: Text('Delete'))
                        : IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => txdelete(Transactions[index].id),
                            color: Colors.red,
                          ),
                  ),
                );
              },
              itemCount: Transactions.length,
            ),
    );
  }
}
