import 'package:expense/widgets/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  const NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDataPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                  onSubmitted: (_) => _submitData,
                ),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Amount",
                  ),
                  onSubmitted: (_) => _submitData,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          _selectedDate == null
                              ? "No Date Chosen"
                              : 'Date Selected: ${DateFormat.yMMMd().format(_selectedDate!)}',
                        ),
                      ),
                      AdaptiveTextButton(
                        text: "Choose A Date",
                        onPressed: _presentDataPicker,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: _submitData,
                  child: const Text("Add Transaction"),
                )
              ]),
        ),
      ),
    );
  }
}
