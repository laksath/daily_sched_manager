import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/sub_task_reminders.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/reminder/bottomBarReminder.dart';
import 'package:daily_schedule_manager/widgets/reminder/reminder_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_schedule_manager/logininfo.dart' as logininf;
import 'appBar.dart';
import 'drawer.dart';

class Reminder extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  Reminder(this._userReminders, this._userTransactions, this._userEntries);
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
      title: "Reminder",
      home: ReminderHomePage(_userReminders, _userTransactions, _userEntries),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  final List<ReminderEntry> _userReminders;
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  ReminderHomePage(
      this._userReminders, this._userTransactions, this._userEntries);
  @override
  _ReminderHomePageState createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var _deleteMode = 0;
  CollectionReference _colref = FirebaseFirestore.instance
      .collection(logininf.email)
      .doc("Reminders")
      .collection("Remin");

  void addReminder({
    String id,
    String heading,
    List<RemiderSubTasks> subTasks,
    DateTime dueDate,
    TimeOfDay dueTime,
  }) {
    CollectionReference _colref1 = FirebaseFirestore.instance
        .collection(logininf.email)
        .doc("Reminders")
        .collection("Remin")
        .doc(id)
        .collection("Subtasks");
    setState(() {
      widget._userReminders.add(
        ReminderEntry(
            id: id,
            heading: heading,
            subTasks: subTasks,
            dueDate: dueDate,
            dueTime: dueTime),
      );
      _colref.doc(id).set({
        'id': id,
        'heading': heading,
        'duedate': dueDate,
        'hour': dueTime.hour,
        'minutes': dueTime.minute,
      });
      for (int i = 0; i < subTasks.length; i++) {
        _colref1.doc(subTasks[i].id).set({
          'id': subTasks[i].id,
          'heading': subTasks[i].heading,
          'duedate': subTasks[i].dueDate,
          'hour': subTasks[i].dueTime == null
              ? dueTime.hour
              : subTasks[i].dueTime.hour,
          'minutes': subTasks[i].dueTime == null
              ? dueTime.minute
              : subTasks[i].dueTime.minute,
          'checkbox': subTasks[i].checkbox,
        });
      }
    });
  }

  void deleteReminderPermission() {
    setState(() {
      _deleteMode = 1;
    });
  }

  void cancelDelete() {
    setState(() {
      _deleteMode = 0;
    });
  }

  void deleteReminder(String id) {
    setState(
      () {
        for (int i = 0; i < widget._userReminders.length; i++) {
          if (widget._userReminders[i].id == id) {
            widget._userReminders.removeAt(i);
            break;
          }
        }
        _colref.doc(id).delete();
      },
    );
  }

  int listLenType = 0;

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
      body: SingleChildScrollView(
        child: Container(
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
              AppBarClass("Reminder", _wd, _topPadding, scaffoldKey),
              Container(
                height: (_ht - 50 - _topPadding) * 0.1,
                width: _wd - 16,
                margin: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: (_ht - 50 - _topPadding) * 0.01,
                ),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: (_ht - 50 - _topPadding) * 0.1,
                        width: (_wd - 16) * 0.49,
                        child: FlatButton(
                          color: Colors.black.withOpacity(0.25),
                          padding: EdgeInsets.all(0),
                          child: Column(
                            children: [
                              Container(
                                height: (_ht - 50 - _topPadding) * 0.05,
                                width: (_wd - 16) * 0.49,
                                child: FittedBox(
                                  child: Text(
                                    "Upcoming",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 1000,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: (_ht - 50 - _topPadding) * 0.05,
                                width: (_wd - 16) * 0.49,
                                child: FittedBox(
                                    child: Text(
                                  "Week",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 1000,
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              listLenType = 0;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: (_ht - 50 - _topPadding) * 0.1,
                        width: (_wd - 16) * 0.02,
                      ),
                      Container(
                        height: (_ht - 50 - _topPadding) * 0.1,
                        width: (_wd - 16) * 0.49,
                        child: FlatButton(
                          color: Colors.black.withOpacity(0.25),
                          child: Column(
                            children: [
                              Container(
                                height: (_ht - 50 - _topPadding) * 0.05,
                                width: (_wd - 16) * 0.49,
                                child: FittedBox(
                                    child: Text(
                                  "All",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 1000,
                                    ),
                                  ),
                                )),
                              ),
                              Container(
                                height: (_ht - 50 - _topPadding) * 0.05,
                                width: (_wd - 16) * 0.49,
                                child: FittedBox(
                                    child: Text(
                                  "Reminders",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 1000,
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              listLenType = 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: (_ht - 50 - _topPadding) * 0.8,
                child: ReminderList(
                  widget._userEntries,
                  widget._userTransactions,
                  widget._userReminders,
                  listLenType,
                  _deleteMode,
                  deleteReminder,
                ),
              ),
              Container(
                height: (_ht - 50 - _topPadding) * 0.08,
                child: BottomBarReminder(
                    widget._userEntries,
                    widget._userTransactions,
                    widget._userReminders,
                    addReminder,
                    deleteReminderPermission,
                    cancelDelete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
