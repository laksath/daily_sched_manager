import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/widgets/appBar.dart';

import 'package:flutter/material.dart';
import '../main.dart';
import 'drawer.dart';
import 'expenses/bottomBar.dart';
import 'expenses/chart.dart';
import 'expenses/newTransaction.dart';
import "../models/transactions.dart";
import 'expenses/transaction_list.dart';
import '../logininfo.dart' as logininf;

class ExpenseManage extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  ExpenseManage(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.blueAccent,
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400))),
      ),
      debugShowCheckedModeBanner: false,
      title: "EXPENSES",
      home: ExpenseHomePage(
        _userEntries,
        _userTransactions,
        _userReminders,
      ),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  ExpenseHomePage(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
  );

  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference _colref = FirebaseFirestore.instance
      .collection(logininf.email)
      .doc("Expenses")
      .collection("Exp");

  int _i = 1;
  int _emptyCheck = 1;
  int _weeklyTransactions = -1;
  List<Transactions> _chartList = [];

  Future<void> _popSheet({Function txType}) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return NewTransactions(txType);
        });
  }

  void _addTransaction({String id, String title, int money, DateTime date}) {
    setState(() {
      widget._userTransactions.add(Transactions(
        id: id == null ? "#$_i" : id,
        money: money,
        text: title,
        date: date,
      ));
      if (id == null) {
        // use _i
        _colref.doc("#" + _i.toString()).set({
          'text': title,
          'money': money,
          'date': date,
          'id': id == null ? "#$_i" : id,
        });
      } else {
        // use id
        _colref.doc(id).set({
          'text': title,
          'money': money,
          'date': date,
          'id': id == null ? "#$_i" : id,
        });
      }

      if (id == null) _i++;
    });
  }

  void _removeTransaction(String id) {
    setState(() {
      for (int i = 0; i < widget._userTransactions.length; i++) {
        if (widget._userTransactions[i].id == id) {
          widget._userTransactions.removeAt(i);
          break;
        }
      }
      _colref.doc(id).delete();
    });
  }

  void _editTransaction(
      {String id, int money, String title, DateTime date}) async {
    _chartList = [];
    _removeTransaction(id);
    var prevId = _i - 1;
    await _popSheet(txType: _addTransaction);
    if (prevId == _i - 1) {
      _addTransaction(id: id, title: title, money: money, date: date);
    }
  }

  List<Transactions> _thisWeekList() {
    var _x = widget._userTransactions.where((element) {
      var _y = DateTime.now();
      return element.date.isBefore(_y
              .subtract(Duration(
                hours: _y.hour,
                minutes: _y.minute,
                seconds: _y.second,
                milliseconds: _y.millisecond,
                microseconds: _y.microsecond,
              ))
              .add(Duration(days: 1))) &&
          element.date.isAfter(_y
              .subtract(Duration(
                hours: _y.hour,
                minutes: _y.minute,
                seconds: _y.second,
                milliseconds: _y.millisecond,
                microseconds: _y.microsecond,
              ))
              .subtract(Duration(days: 6)));
    }).toList();
    _x.sort((a, b) {
      return a.date.isBefore(b.date) ? 1 : 0;
    });
    return _x;
  }

  List<Transactions> get _list {
    var _x = widget._userTransactions;
    if (_weeklyTransactions == -1) {
      return _thisWeekList();
    }
    _x.sort((a, b) {
      return a.date.isBefore(b.date) ? 1 : 0;
    });
    return _x;
  }

  void _weekWiseChart(DateTime weeklyChart) {
    var _x = widget._userTransactions.where((element) {
      return element.date.isBefore(weeklyChart.add(Duration(days: 1))) &&
          element.date.isAfter(weeklyChart.subtract(Duration(days: 6)));
    }).toList();
    _x.sort((a, b) {
      return a.date.isAfter(b.date) ? 1 : 0;
    });
    var date = weeklyChart;
    if (_x.isEmpty) {
      for (int i = 0; i < 7; i++) {
        _x.add(Transactions(id: "#_i", text: "-", money: 0, date: date));
        date = date.subtract(Duration(days: 1));
        _i++;
      }

      _chartList = _x.toList();

      setState(() {});
      return;
    } else {
      date = _x[_x.length - 1].date;

      while (_x[_x.length - 1].date.isBefore(weeklyChart)) {
        date = date.add(Duration(days: 1));
        _x.add(Transactions(id: "#_i", text: "-", money: 0, date: date));
        _i++;
      }
    }

    _chartList = _x.reversed.toList();
    setState(() {});
  }

  int get emptyChart {
    _chartList = [];
    return 1;
  }

  void _plus() {
    _popSheet(txType: _addTransaction);
  }

  void _viewFullTx() {
    setState(() {
      _weeklyTransactions *= -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _wd = MediaQuery.of(context).size.width;
    final _topPadding = MediaQuery.of(context).padding.top;
    int maxId = 0;
    if (_emptyCheck == 1) {
      if (widget._userTransactions.length != 0) {
        maxId = int.parse(widget._userTransactions[0].id.substring(1));
        for (int i = 0; i < widget._userTransactions.length; i++) {
          if (int.parse(widget._userTransactions[i].id.substring(1)) > maxId) {
            maxId = int.parse(widget._userTransactions[i].id.substring(1));
          }
        }
      }
    }

    if (maxId != 0 && _emptyCheck == 1) {
      _i = maxId + 1;
    }

    _emptyCheck = 0;
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(
        _ht,
        _wd,
        _topPadding,
        widget._userTransactions,
        widget._userEntries,
        widget._userReminders,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.redAccent,
              Colors.indigo,
            ],
          ),
        ),
        child: Column(
          children: [
            AppBarClass("Expense Manager", _wd, _topPadding, scaffoldKey),
            Container(
              child: _chartList.isEmpty
                  ? Container(
                      child: Chart(_thisWeekList(), null, emptyChart),
                      height: (_ht - 50) * 0.33 - _topPadding,
                    )
                  : Container(
                      child: Chart(_chartList, _chartList[0].date, emptyChart),
                      height: (_ht - 50) * 0.33 - _topPadding,
                    ),
            ),
            Container(
              height: (_ht - 50) * 0.57,
              child: TransactionList(
                  transactions: _list,
                  deletion: _removeTransaction,
                  editing: _editTransaction),
            ),
            Container(
              child: BottomBar(
                  _weekWiseChart, _plus, _viewFullTx, _weeklyTransactions),
              height: (_ht - 50) * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
