import 'package:expensetracker/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class transactionList extends StatelessWidget {
  final List<Transaction> Transactions;

  transactionList(this.Transactions);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Transactions.isEmpty
          ? 
          Column(children: [
              Text('No Transactions Added Yet !!', style: TextStyle(fontSize: 30),),
              SizedBox(height: 30,),
              Container(height: 100 ,child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover)),
            ])
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColorDark,
                          width: 1.5,
                        )),
                        child: Text(
                          '₹: ' + Transactions[index].amount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Transactions[index].title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd().format(
                              Transactions[index].date,
                            ),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                  elevation: 10,
                );
              },
              itemCount: Transactions.length,
            ),
    );
  }
}
