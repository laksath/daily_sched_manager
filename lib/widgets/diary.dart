import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/appBar.dart';
import 'package:daily_schedule_manager/widgets/drawer.dart';

import '../logininfo.dart' as logininf;
import '../main.dart';
import '../models/diary_entries.dart';
import '../widgets/diary/bottomBarDiary.dart';
import '../widgets/diary/diary_list.dart';
import '../widgets/diary/editEntry.dart';
import 'package:flutter/material.dart';

class Diary extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  Diary(this._userReminders, this._userTransactions, this._userEntries);

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
      title: "Diary",
      home: DiaryHomePage(_userReminders, _userTransactions, _userEntries),
    );
  }
}

class DiaryHomePage extends StatefulWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  DiaryHomePage(this._userReminders, this._userTransactions, this._userEntries);
  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _day = DateTime.now();
  CollectionReference _colref = FirebaseFirestore.instance
      .collection(logininf.email)
      .doc("Diary")
      .collection("Diar");
  void _addEntry(
      {String id,
      String title,
      String heading,
      TimeOfDay time,
      DateTime date}) {
    setState(() {
      widget._userEntries.add(DiaryEntry(
        id: id == null ? DateTime.now().toString() : id,
        text: title,
        date: date,
        time: time,
        heading: heading,
      ));
      _colref.doc(id).set({
        'id': id == null ? DateTime.now().toString() : id,
        'text': title,
        'date': date,
        'hour': time.hour,
        'minutes': time.minute,
        'heading': heading,
      });
    });
  }

  void _removeEntry(String id) {
    setState(
      () {
        for (int i = 0; i < widget._userEntries.length; i++) {
          if (widget._userEntries[i].id == id) {
            widget._userEntries.removeAt(i);
            break;
          }
        }

        _colref.doc(id).delete();
      },
    );
  }

  void _editEntry(
      {String id,
      String heading,
      String title,
      TimeOfDay time,
      DateTime date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntry(
          id,
          heading,
          title,
          time,
          date,
          widget._userEntries,
          _addEntry,
          _removeEntry,
          widget._userReminders,
          widget._userTransactions,
        ),
      ),
    );
  }

  void dayChanger(DateTime day) {
    setState(() {
      _day = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _wd = MediaQuery.of(context).size.width;
    final _topPadding = MediaQuery.of(context).padding.top;

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
            AppBarClass("Diary", _wd, _topPadding, scaffoldKey),
            Container(
              height: (_ht - 50 - _topPadding) * 0.92,
              child: DiaryList(
                widget._userEntries,
                _removeEntry,
                _editEntry,
                _day == null
                    ? null
                    : DateTime.utc(_day.year, _day.month, _day.day + 1),
                widget._userTransactions,
                widget._userReminders,
              ),
            ),
            Container(
              height: (_ht - 50 - _topPadding) * 0.08,
              child: BottomBarDiary(
                dayChanger,
                _addEntry,
                widget._userTransactions,
                widget._userEntries,
                widget._userReminders,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
