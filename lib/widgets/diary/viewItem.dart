import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';

import '../../models/diary_entries.dart';
import '../diary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../postauth.dart';

class ViewEntry extends StatelessWidget {
  final String id;
  final String heading;
  final String title;
  final TimeOfDay time;
  final DateTime date;
  final List<DiaryEntry> diaryEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  ViewEntry(
    this.id,
    this.heading,
    this.title,
    this.time,
    this.date,
    this.diaryEntries,
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
      title: "Diary",
      home: DiaryHomePage(
        id,
        heading,
        title,
        time,
        date,
        diaryEntries,
        _userTransactions,
        _userReminders,
      ),
    );
  }
}

class DiaryHomePage extends StatefulWidget {
  final String id;
  final String heading;
  final String title;
  final TimeOfDay time;
  final DateTime date;
  final List<DiaryEntry> diaryEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  DiaryHomePage(
    this.id,
    this.heading,
    this.title,
    this.time,
    this.date,
    this.diaryEntries,
    this._userTransactions,
    this._userReminders,
  );

  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  DateTime _chosenDate;
  TimeOfDay _chosenTime;

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _wd = MediaQuery.of(context).size.width;
    final _topPadding = MediaQuery.of(context).padding.top;
    _chosenDate = widget.date;
    _chosenTime = widget.time;

    return Scaffold(
      body: Container(
        color: Colors.white12,
        child: Column(
          children: [
            Container(
              height: (_ht) * 0.1,
              margin: EdgeInsets.only(
                top: _topPadding,
              ),
              child: Column(
                children: [
                  Container(
                    width: (_wd - 6),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: (_ht) * 0.1 * 0.3,
                      width: (_wd - 6) * 0.5,
                      child: FittedBox(
                        child: Text(
                          _chosenTime.minute < 10
                              ? "Time :  ${_chosenTime.hour}:0${_chosenTime.minute}"
                              : "Time :  ${_chosenTime.hour}:${_chosenTime.minute}",
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: (_wd - 6) * 0.7,
                    height: (_ht) * 0.1 * 0.3,
                    alignment: Alignment.topLeft,
                    child: FittedBox(
                      child: Text(
                        "Date :  ${DateFormat.yMMMMd().format(_chosenDate)} ${DateFormat("EEEE").format(_chosenDate)}",
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: (_ht) * 0.1 * 0.1),
                    alignment: Alignment.center,
                    height: (_ht) * 0.1 * 0.3,
                    width: (_wd - 6) * 0.7,
                    child: SizedBox(
                      width: (_wd - 6) * 0.8,
                      child: Container(
                        child: (widget.heading != null)
                            ? Text(
                                widget.heading,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (_ht) * 0.1 * 0.25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Times New Roman",
                                  color: Colors.blue,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: (_ht) * 0.8 - _topPadding,
              width: (_wd - 6),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(
                  left: _wd * 0.05, right: _wd * 0.05, top: (_ht) * 0.01),
              child: SingleChildScrollView(
                child: Container(
                  child: Text(
                    widget.title,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: (_ht) * 0.09,
              child: Row(
                children: [
                  Container(
                    height: (_ht) * 0.09,
                    width: _wd / 2,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        "Back\nto\nDiary",
                        style: TextStyle(
                          color: Colors.indigo[600],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Diary(
                              widget._userReminders,
                              widget._userTransactions,
                              widget.diaryEntries,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: (_ht) * 0.09,
                    width: _wd / 2,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.home,
                        color: Colors.indigo[300],
                        size: (_ht) * 0.05,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
