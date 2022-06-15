import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;
  const TransactionList(this.userTransactions, this.deleteTransaction,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  "No Transactions Yet",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          }))
        : ListView.builder(
            itemCount: userTransactions.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                          "\$${userTransactions[index].amount}",
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    userTransactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(userTransactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? TextButton.icon(
                          onPressed: () =>
                              deleteTransaction(userTransactions[index].id),
                          icon: const Icon(Icons.delete),
                          label: const Text("delete"),
                          style: TextButton.styleFrom(
                            primary: Theme.of(context).errorColor,
                          ),
                        )
                      : IconButton(
                          onPressed: () =>
                              deleteTransaction(userTransactions[index].id),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                ),
              );
            },
          );
  }
}
