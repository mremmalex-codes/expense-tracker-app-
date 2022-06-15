import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expenses App",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "QuickSand",
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              button: const TextStyle(color: Colors.white),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: "t1", title: "New Shoe", amount: 99.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "New Cloths", amount: 50.99, date: DateTime.now())
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: date,
    );

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _openAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Expenses App"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _openAddNewTransaction(context),
                  child: const Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text("Expenses App"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _openAddNewTransaction(context),
              ),
            ],
          )) as PreferredSizeWidget;

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLandScape)
              Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Text("Show Chart"),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      })
                ]),
              ),
            if (!isLandScape)
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandScape)
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: TransactionList(_userTransactions, _deleteTransaction),
              ),
            if (isLandScape)
              _showChart
                  ? SizedBox(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : SizedBox(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: TransactionList(
                          _userTransactions, _deleteTransaction),
                    ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: appBody,
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _openAddNewTransaction(context),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: appBar,
            body: appBody,
          );
  }
}
