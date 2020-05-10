import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';


main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
              fontFamily: 'OpanSans',
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          )
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpanSans',
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          )
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }
  
  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_){
      return TransactionForm(_addTransaction);
    });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id){
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }
  Widget _getIconButton(IconData icon, Function fn){
    return Platform.isIOS ?
    GestureDetector(onTap: fn, child: Icon(icon),) :
    IconButton( icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;
    final actions = <Widget>[
          if(isLandscape) 
          _getIconButton(
            _showChart ? iconList : chartList,
            () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
          _getIconButton(
            Platform.isIOS ? CupertinoIcons.add : Icons.add,
            () => _opentransactionFormModal(context),
          ),
        ];
    final PreferredSizeWidget appBar = Platform.isIOS 
    ? CupertinoNavigationBar(
      middle: Text('Despesas Pessoais'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    ) 
    : AppBar(
        title: Text('Despesas Pessoais'),
        actions: actions,
    );
    final availabelHeight = mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;
    final bodyPage = SafeArea(
      child:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // if(isLandscape) 
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text('Exibir Gráfico'),
            //     Switch.adaptive(
            //       activeColor: Theme.of(context).accentColor,
            //       value: _showChart, 
            //       onChanged: (value) {
            //         setState(() {
            //           _showChart = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            if (_showChart || !isLandscape)
            Container(
              height: availabelHeight * (isLandscape ? 0.8 : 0.30),
              child: Chart(_recentTransactions)
            ),
            if (!_showChart || !isLandscape)
            Container(
              height: availabelHeight * (isLandscape ? 1 : 0.70),
              child: TransactionList(_transactions, _removeTransaction)
            )
          ],
        ),
      ),
    );
    return Platform.isIOS 
    ? CupertinoPageScaffold(
      navigationBar: appBar,
      child: bodyPage
    ) 
    : Scaffold(
      appBar: appBar,
      body: bodyPage,
      floatingActionButton: Platform.isIOS 
      ? Container() 
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _opentransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}