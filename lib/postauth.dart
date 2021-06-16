import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_schedule_manager/models/sub_task_reminders.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/appBar.dart';
import 'package:daily_schedule_manager/widgets/drawer.dart';
import 'package:daily_schedule_manager/widgets/reminder.dart';
import './models/diary_entries.dart';
import './models/reminider_entries.dart';
import './widgets/diary.dart';
import 'package:flutter/material.dart';
import './widgets/expense.dart';
import 'logininfo.dart' as logininf;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      title: "HOME",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int called = 0;

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _topPadding = MediaQuery.of(context).padding.top;
    final _wd = MediaQuery.of(context).size.width;

    List<DiaryEntry> _userEntries = [];
    List<Transactions> _userTransactions = [];
    List<ReminderEntry> _userReminders = [];
    List<RemiderSubTasks> _remidersubtask = [];

    Future<List<RemiderSubTasks>> subTasks(String documentid) async {
      QuerySnapshot snaprms = await FirebaseFirestore.instance
          .collection(logininf.email)
          .doc("Reminders")
          .collection("Remin")
          .doc(documentid)
          .collection("Subtasks")
          .get();
      _remidersubtask = [];
      snaprms.docs.forEach((document) {
        _remidersubtask.add(RemiderSubTasks(
          id: document.get('id'),
          heading: document.get('heading'),
          checkbox: document.get('checkbox'),
          dueDate: document.get('duedate') == null
              ? null
              : document.get('duedate').toDate(),
          dueTime: TimeOfDay(
              hour: document.get('hour'), minute: document.get('minutes')),
        ));
      });

      return _remidersubtask;
    }

    Future<void> getData() async {
      print("function call");
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection(logininf.email)
          .doc("Expenses")
          .collection("Exp")
          .get();
      QuerySnapshot snapd = await FirebaseFirestore.instance
          .collection(logininf.email)
          .doc("Diary")
          .collection("Diar")
          .get();
      QuerySnapshot snapr = await FirebaseFirestore.instance
          .collection(logininf.email)
          .doc("Reminders")
          .collection("Remin")
          .get();

      snap.docs.forEach(
        (document) {
          _userTransactions.add(Transactions(
              id: document.get("id"),
              text: document.get("text"),
              money: document.get("money"),
              date: document.get("date").toDate()));
        },
      );

      snapd.docs.forEach(
        (document) {
          _userEntries.add(DiaryEntry(
            id: document.get('id'),
            heading: document.get('heading'),
            text: document.get('text'),
            date: document.get('date').toDate(),
            time: TimeOfDay(
                hour: document.get('hour'), minute: document.get('minutes')),
          ));
        },
      );

      snapr.docs.forEach(
        (document) async {
          _userReminders.add(
            ReminderEntry(
              id: document.get('id'),
              heading: document.get('heading'),
              dueDate: document.get('duedate').toDate(),
              dueTime: TimeOfDay(
                  hour: document.get('hour'), minute: document.get('minutes')),
              subTasks: await subTasks(document.id),
            ),
          );
        },
      );
    }

    if (called == 0) {
      getData();
      called = 1;
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(
        _ht,
        _wd,
        _topPadding,
        _userTransactions,
        _userEntries,
        _userReminders,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.green,
              Colors.blue,
            ],
          ),
        ),
        child: Column(
          children: [
            AppBarClass("Home Page", _wd, _topPadding, scaffoldKey),
            SizedBox(
              height: (_ht - 50 - _topPadding) * 0.05,
            ),
            RaisedButton(
              child: Container(
                margin: EdgeInsets.only(
                    top: (_ht - 50 - _topPadding) * 0.02,
                    left: _wd * 0.05,
                    right: _wd * 0.05),
                height: (_ht - 50 - _topPadding) * 0.2,
                width: _wd * 0.9,
                child: FittedBox(
                  child: Text(
                    "DAILY SCHEDULE MANAGER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 1000,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                ),
              ),
              onPressed: null,
            ),
            Container(
              margin: EdgeInsets.only(
                top: (_ht - 50 - _topPadding) * 0.02,
              ),
              height: (_ht - 50 - _topPadding) * 0.2,
              width: _wd * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: FlatButton(
                color: Colors.black.withOpacity(0.3),
                child: FittedBox(
                  child: Container(
                    child: Text(
                      "REMINDERS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Reminder(
                            _userReminders, _userTransactions, _userEntries)),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: (_ht - 50 - _topPadding) * 0.02,
              ),
              height: (_ht - 50 - _topPadding) * 0.2,
              width: _wd * 0.95,
              child: FlatButton(
                color: Colors.black.withOpacity(0.3),
                child: FittedBox(
                  child: Text(
                    "EXPENSES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpenseManage(
                              _userEntries,
                              _userTransactions,
                              _userReminders,
                            )),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: (_ht - 50 - _topPadding) * 0.02,
              ),
              height: (_ht - 50 - _topPadding) * 0.2,
              width: _wd * 0.95,
              child: FlatButton(
                color: Colors.black.withOpacity(0.3),
                child: FittedBox(
                  child: Text(
                    "DIARY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Diary(
                        _userReminders,
                        _userTransactions,
                        _userEntries,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: (_ht - 50 - _topPadding) * 0.07,
            )
          ],
        ),
      ),
    );
  }
}
