import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/appBar.dart';
import 'package:daily_schedule_manager/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../postauth.dart';
import '../reminder.dart';
import 'package:daily_schedule_manager/logininfo.dart' as logininf;

class ViewReminder extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  final int listLenType;
  final int _deleteMode;
  final Function deleteReminder;
  final List<ReminderEntry> _finalList;
  final int _i;
  ViewReminder(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
    this.listLenType,
    this._deleteMode,
    this.deleteReminder,
    this._finalList,
    this._i,
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
      title: "HOME",
      home: ViewReminderPage(
        _userEntries,
        _userTransactions,
        _userReminders,
        listLenType,
        _deleteMode,
        deleteReminder,
        _finalList,
        _i,
      ),
    );
  }
}

class ViewReminderPage extends StatefulWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  final int listLenType;
  final int _deleteMode;
  final Function deleteReminder;
  final List<ReminderEntry> _finalList;
  final int _i;

  ViewReminderPage(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
    this.listLenType,
    this._deleteMode,
    this.deleteReminder,
    this._finalList,
    this._i,
  );

  @override
  _ViewReminderPageState createState() => _ViewReminderPageState();
}

class _ViewReminderPageState extends State<ViewReminderPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _topPadding = MediaQuery.of(context).padding.top;
    final _wd = MediaQuery.of(context).size.width;
    var _subtaskEntries = widget._finalList[widget._i].subTasks;
    for (int i = 0; i < _subtaskEntries.length; i++) {
      print("+");
      if (_subtaskEntries[i].dueTime == null) {
        _subtaskEntries[i].dueTime = TimeOfDay(
            hour: widget._finalList[widget._i].dueTime.hour,
            minute: widget._finalList[widget._i].dueTime.minute);
      }
    }
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
              Colors.red,
              Colors.blue,
            ],
          ),
        ),
        child: Column(
          children: [
            AppBarClass("View Reminder", _wd, _topPadding, scaffoldKey),
            Container(
              height: (_ht - 50 - _topPadding) * 0.3,
              width: _wd * 0.95,
              margin: EdgeInsets.only(
                top: (_ht - 50 - _topPadding) * 0.05,
              ),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 15,
                shadowColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075,
                          padding: EdgeInsets.only(left: 5),
                          width: _wd * 0.3,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Heading :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075,
                          padding: EdgeInsets.only(right: 5),
                          width: _wd * 0.65,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " ${widget._finalList[widget._i].heading}",
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.w300,
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075,
                          width: _wd * 0.3,
                          padding: EdgeInsets.only(left: 5),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Due Date :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075 / 1.5,
                          width: _wd * 0.65,
                          padding: EdgeInsets.only(right: 5),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " ${DateFormat.yMMMMd().format(widget._finalList[widget._i].dueDate)}",
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075,
                          width: _wd * 0.3,
                          padding: EdgeInsets.only(left: 5),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Due Time :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075 / 1.5,
                          width: _wd * 0.65,
                          padding: EdgeInsets.only(right: 5),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget._finalList[widget._i].dueTime.minute < 10
                                  ? " ${widget._finalList[widget._i].dueTime.hour}:0${widget._finalList[widget._i].dueTime.minute}"
                                  : " ${widget._finalList[widget._i].dueTime.hour}:${widget._finalList[widget._i].dueTime.minute}",
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075,
                          width: _wd * 0.3,
                          padding: EdgeInsets.only(left: 5),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "SubTasks :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: (_ht - 50 - _topPadding) * 0.075 / 1.5,
                          width: _wd * 0.65,
                          padding: EdgeInsets.only(right: 5),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " ${_subtaskEntries.length}",
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 1000,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (_ht - 50 - _topPadding) * 0.6,
              width: _wd * 0.95,
              margin: EdgeInsets.symmetric(horizontal: _wd * 0.025),
              child: ListView.builder(
                itemCount: _subtaskEntries.length,
                itemBuilder: (function, i) {
                  return Container(
                    padding: EdgeInsets.zero,
                    width: _wd * 0.95,
                    height: (_ht - 50 - _topPadding) * 0.175,
                    margin: EdgeInsets.only(top: 15),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shadowColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 15,
                      child: Column(
                        children: [
                          Container(
                            height: (_ht - 50 - _topPadding) * 0.075,
                            child: Row(
                              children: [
                                Container(
                                  width: _wd * 0.1,
                                  height: (_ht - 50 - _topPadding) * 0.075,
                                  child: Checkbox(
                                    value: _subtaskEntries[i].checkbox,
                                    checkColor: Colors.black,
                                    activeColor: Colors.white,
                                    splashRadius: 50,
                                    onChanged: (bool x) {
                                      setState(() {
                                        DocumentReference _colref =
                                            FirebaseFirestore.instance
                                                .collection(logininf.email)
                                                .doc("Reminders")
                                                .collection("Remin")
                                                .doc((widget
                                                    ._userReminders[widget._i]
                                                    .id))
                                                .collection("Subtasks")
                                                .doc(_subtaskEntries[i].id);
                                        if (_subtaskEntries[i].checkbox ==
                                            true) {
                                          _subtaskEntries[i].checkbox = false;
                                          _colref.update({'checkbox': false});
                                        } else {
                                          _subtaskEntries[i].checkbox = true;
                                          _colref.update({'checkbox': true});
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  height: (_ht - 50 - _topPadding) * 0.075,
                                  width: _wd * 0.25,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Heading :",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 1000,
                                          fontWeight: FontWeight.w300,
                                          decoration:
                                              _subtaskEntries[i].checkbox ==
                                                      false
                                                  ? null
                                                  : TextDecoration.lineThrough),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: (_ht - 50 - _topPadding) * 0.075,
                                  width: _wd * 0.6,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      " ${_subtaskEntries[i].heading}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 1000,
                                          fontWeight: FontWeight.w300,
                                          decoration:
                                              _subtaskEntries[i].checkbox ==
                                                      false
                                                  ? null
                                                  : TextDecoration.lineThrough),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: (_ht - 50 - _topPadding) * 0.05,
                            width: _wd * 0.95,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height:
                                                (_ht - 50 - _topPadding) * 0.05,
                                            width: _wd * 0.1,
                                          ),
                                          Container(
                                            height:
                                                (_ht - 50 - _topPadding) * 0.05,
                                            width: _wd * 0.25,
                                            child: FittedBox(
                                              child: Text(
                                                "Due Date :",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 1000,
                                                  decoration: _subtaskEntries[i]
                                                              .checkbox ==
                                                          false
                                                      ? null
                                                      : TextDecoration
                                                          .lineThrough,
                                                ),
                                              ),
                                            ),
                                          ),
                                          _subtaskEntries[i].dueDate != null
                                              ? Container(
                                                  height:
                                                      (_ht - 50 - _topPadding) *
                                                          0.05,
                                                  width: _wd * 0.6,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: FittedBox(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      " ${DateFormat.yMMMMd().format(_subtaskEntries[i].dueDate)}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 1000,
                                                        decoration: _subtaskEntries[
                                                                        i]
                                                                    .checkbox ==
                                                                false
                                                            ? null
                                                            : TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height:
                                                      (_ht - 50 - _topPadding) *
                                                          0.04,
                                                  width: _wd * 0.6,
                                                  child: FittedBox(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      " ${DateFormat.yMMMMd().format(widget._finalList[widget._i].dueDate)}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black,
                                                        fontSize: 1000,
                                                        decoration: _subtaskEntries[
                                                                        i]
                                                                    .checkbox ==
                                                                false
                                                            ? null
                                                            : TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: (_ht - 50 - _topPadding) * 0.05,
                            width: _wd * 0.95,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: (_ht - 50 - _topPadding) * 0.05,
                                  width: _wd * 0.1,
                                ),
                                Container(
                                  height: (_ht - 50 - _topPadding) * 0.05,
                                  width: _wd * 0.25,
                                  child: FittedBox(
                                    child: Text(
                                      "Due Time :",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontSize: 1000,
                                        decoration:
                                            _subtaskEntries[i].checkbox == false
                                                ? null
                                                : TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: (_ht - 50 - _topPadding) * 0.04,
                                  width: _wd * 0.6,
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Text(
                                      _subtaskEntries[i].dueTime.minute < 10
                                          ? " ${_subtaskEntries[i].dueTime.hour}:0${_subtaskEntries[i].dueTime.minute}"
                                          : " ${_subtaskEntries[i].dueTime.hour}:${_subtaskEntries[i].dueTime.minute}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontSize: 1000,
                                        decoration:
                                            _subtaskEntries[i].checkbox == false
                                                ? null
                                                : TextDecoration.lineThrough,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: (_ht - 50 - _topPadding) * 0.05,
              width: _wd,
              child: Row(
                children: [
                  Container(
                    height: (_ht - 50 - _topPadding) * 0.05,
                    width: _wd * 0.33,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      color: Colors.blue,
                      child: FittedBox(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: (_ht - 50 - _topPadding) * 0.07,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Reminder(
                              widget._userReminders,
                              widget._userTransactions,
                              widget._userEntries,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: (_ht - 50 - _topPadding) * 0.05,
                    width: _wd * 0.34,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      color: Colors.indigo,
                      child: FittedBox(
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: (_ht - 50 - _topPadding) * 0.07,
                        ),
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
                  Container(
                    width: _wd * 0.33,
                    height: (_ht - 50 - _topPadding) * 0.05,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      splashColor: Colors.red,
                      child: FittedBox(
                        child: Icon(
                          Icons.done,
                          size: (_ht - 50 - _topPadding) * 0.07,
                        ),
                      ),
                      color: Colors.green[600],
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reminder(
                                    widget._userReminders,
                                    widget._userTransactions,
                                    widget._userEntries,
                                  )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
