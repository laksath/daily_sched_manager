import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/sub_task_reminders.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/appBar.dart';
import 'package:daily_schedule_manager/widgets/drawer.dart';
import 'package:daily_schedule_manager/widgets/reminder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../postauth.dart';

class NewReminder extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  final Function _addReminder;
  final DateTime _today;
  NewReminder(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
    this._addReminder,
    this._today,
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
      title: "Reminder",
      home: NewReminderPage(
        _userEntries,
        _userTransactions,
        _userReminders,
        _addReminder,
        _today,
      ),
    );
  }
}

class NewReminderPage extends StatefulWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  final Function _addReminder;
  final DateTime _today;
  NewReminderPage(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
    this._addReminder,
    this._today,
  );
  @override
  _NewReminderPageState createState() => _NewReminderPageState();
}

class _NewReminderPageState extends State<NewReminderPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleTextField = TextEditingController();
  List<RemiderSubTasks> _subtaskEntries = [];
  final List<TextEditingController> _titleControllers = [];
  var _chosenDateString = "";
  var _chosenTimeString = "";

  void _displayDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: widget._today,
      firstDate: widget._today,
      lastDate: DateTime.utc(widget._today.year + 2),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _chosenDateString = "${value.day}/${value.month}/${value.year}";
      });
    });
  }

  void _displayTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: widget._today.hour, minute: widget._today.minute),
    ).then(
      (value) {
        if (value == null) return;
        setState(() {
          _chosenTimeString = value.minute < 10
              ? "Time Chosen :   ${value.hour}:0${value.minute}"
              : "Time Chosen :   ${value.hour}:${value.minute}";
        });
      },
    );
  }

  void _displayDatePickerSubTask(BuildContext context, int i) {
    showDatePicker(
      context: context,
      initialDate: widget._today,
      firstDate: widget._today,
      lastDate: DateTime.utc(widget._today.year + 2),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _subtaskEntries[i].dueDate = value;
      });
    });
  }

  void _displayTimePickerSubTask(BuildContext context, int i) {
    showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: widget._today.hour, minute: widget._today.minute),
    ).then(
      (value) {
        if (value == null) return;
        setState(() {
          _subtaskEntries[i].dueTime = value;
        });
      },
    );
  }

  void _addSubTask() {
    setState(() {
      _subtaskEntries.add(
        RemiderSubTasks(
          id: DateTime.now().toString(),
          checkbox: false,
          heading: "",
        ),
      );
      _titleControllers.add(TextEditingController());
    });
  }

  void _deleteSubTask(int i) {
    setState(() {
      _subtaskEntries.removeAt(i);
      _titleControllers.removeAt(i);
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
      body: SingleChildScrollView(
        child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarClass("New Reminder", _wd, _topPadding, scaffoldKey),
              Container(
                width: _wd * 0.95,
                height: (_ht - 50 - _topPadding) * 0.48,
                margin: EdgeInsets.only(
                  top: (_ht - 50 - _topPadding) * 0.01,
                  left: _wd * 0.025,
                  right: _wd * 0.025,
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 60,
                  shadowColor: Colors.indigo,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: _wd * 0.02,
                          right: _wd * 0.02,
                        ),
                        height: (_ht - 50 - _topPadding) * 0.075,
                        child: Row(
                          children: [
                            Container(
                              width: _wd * 0.91,
                              child: TextField(
                                controller: _titleTextField,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: (_ht - 50 - _topPadding) * 0.035,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Reminder Name',
                                  contentPadding: EdgeInsets.only(
                                      top: (_ht - 50 - _topPadding) * 0.035),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: _wd * 0.91,
                        margin: EdgeInsets.only(
                          top: (_ht - 50 - _topPadding) * 0.04,
                          left: _wd * 0.02,
                          right: _wd * 0.02,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _wd * 0.45,
                              height: (_ht - 50 - _topPadding) * 0.035,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Set Due Date :",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: _wd * 0.26,
                            ),
                            Container(
                              height: (_ht - 50 - _topPadding) * 0.035,
                              width: _wd * 0.2,
                              child: Container(
                                child: RaisedButton(
                                  color: Colors.indigo[200],
                                  child: FittedBox(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 5000,
                                    ),
                                  ),
                                  onPressed: () {
                                    _displayDatePicker(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: (_ht - 50 - _topPadding) * 0.04,
                          left: _wd * 0.02,
                          right: _wd * 0.02,
                        ),
                        width: _wd * 0.91,
                        height: (_ht - 50 - _topPadding) * 0.035,
                        child: Row(
                          children: [
                            Container(
                              width: _wd * 0.45,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _chosenDateString == ""
                                      ? "Default Date Chosen :"
                                      : "Date Chosen :",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: _wd * 0.26,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              width: _wd * 0.2,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _chosenDateString == ""
                                      ? "${widget._today.day}/${widget._today.month}/${widget._today.year}"
                                      : _chosenDateString,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: (_ht - 50 - _topPadding) * 0.04,
                            left: _wd * 0.02,
                            right: _wd * 0.02),
                        height: (_ht - 50 - _topPadding) * 0.035,
                        width: _wd * 0.91,
                        child: Row(
                          children: [
                            Container(
                              width: _wd * 0.45,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Set Due Time :",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: _wd * 0.26,
                            ),
                            Container(
                              width: _wd * 0.2,
                              child: Container(
                                child: RaisedButton(
                                  color: Colors.indigo[200],
                                  child: FittedBox(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.watch_later_outlined,
                                      size: 5000,
                                    ),
                                  ),
                                  onPressed: () {
                                    _displayTimePicker(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: (_ht - 50 - _topPadding) * 0.04,
                          left: _wd * 0.02,
                          right: _wd * 0.02,
                        ),
                        width: _wd * 0.91,
                        height: (_ht - 50 - _topPadding) * 0.035,
                        child: Row(
                          children: [
                            Container(
                              width: _wd * 0.45,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _chosenTimeString == ""
                                      ? "Default Time Chosen :"
                                      : "Time Chosen :",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: _wd * 0.26,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              width: _wd * 0.2,
                              child: FittedBox(
                                child: Text(
                                  widget._today.minute < 10
                                      ? "${widget._today.hour}:0${widget._today.minute}"
                                      : "${widget._today.hour}:${widget._today.minute}",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: (_ht - 50 - _topPadding) * 0.04,
                          bottom: (_ht - 50 - _topPadding) * 0.03,
                          left: _wd * 0.02,
                          right: _wd * 0.02,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _wd * 0.45,
                              height: (_ht - 50 - _topPadding) * 0.035,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Add Subtasks (Optional) :",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize:
                                          (_ht - 50 - _topPadding) * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: _wd * 0.26,
                            ),
                            Container(
                              width: _wd * 0.2,
                              height: (_ht - 50 - _topPadding) * 0.035,
                              child: Container(
                                child: RaisedButton(
                                  color: Colors.indigo[200],
                                  child: FittedBox(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      size: 5000,
                                    ),
                                  ),
                                  onPressed: () {
                                    _addSubTask();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: (_ht - 50 - _topPadding) * (0.46),
                width: _wd * 0.9,
                margin: EdgeInsets.only(left: _wd * 0.05, right: _wd * 0.05),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _subtaskEntries.length,
                  itemBuilder: (function, i) {
                    return Container(
                      margin: EdgeInsets.only(top: 5),
                      height: (_ht - 50 - _topPadding) * 0.2,
                      width: _wd * 0.9,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.zero,
                        shadowColor: Theme.of(context).primaryColor,
                        elevation: 15,
                        child: Column(
                          children: [
                            Container(
                              height: (_ht - 50 - _topPadding) * 0.1,
                              child: Row(
                                children: [
                                  Container(
                                    width: _wd * 0.1,
                                  ),
                                  Container(
                                    width: _wd * 0.6,
                                    child: TextField(
                                      controller: _titleControllers[i],
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize:
                                              (_ht - 50 - _topPadding) * 0.03,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter the SubTask ${i + 1}',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.05,
                                  ),
                                  Container(
                                    width: _wd * 0.1,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      splashColor: Colors.red,
                                      onPressed: () {
                                        _deleteSubTask(i);
                                      },
                                      child: Icon(
                                        Icons.delete_forever_outlined,
                                      ),
                                      color: Colors.red[100],
                                      textColor: Colors.red,
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.05,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: (_ht - 50 - _topPadding) * 0.1,
                              child: Row(
                                children: [
                                  Container(
                                    width: _wd * 0.03,
                                  ),
                                  Container(
                                    height: (_ht - 50 - _topPadding) * 0.1,
                                    width: _wd * 0.2,
                                    child: FittedBox(
                                      child: Text(
                                        _subtaskEntries[i].dueDate == null
                                            ? ""
                                            : DateFormat.yMMMd().format(
                                                _subtaskEntries[i].dueDate),
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize:
                                                (_ht - 50 - _topPadding) * 0.03,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.01,
                                  ),
                                  Container(
                                    height: (_ht - 50 - _topPadding) * 0.1,
                                    width: _wd * 0.2,
                                    child: Row(
                                      children: [
                                        Container(
                                          height:
                                              (_ht - 50 - _topPadding) * 0.1,
                                          width: _wd * 0.025,
                                        ),
                                        Container(
                                          height:
                                              (_ht - 50 - _topPadding) * 0.1,
                                          width: _wd * 0.1,
                                          child: FittedBox(
                                            child: Text(
                                              _subtaskEntries[i].dueTime == null
                                                  ? ""
                                                  : _subtaskEntries[i]
                                                              .dueTime
                                                              .minute <
                                                          10
                                                      ? "${_subtaskEntries[i].dueTime.hour}:0${_subtaskEntries[i].dueTime.minute}"
                                                      : "${_subtaskEntries[i].dueTime.hour}:${_subtaskEntries[i].dueTime.minute}",
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  fontSize:
                                                      (_ht - 50 - _topPadding) *
                                                          0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.01,
                                  ),
                                  Container(
                                    height: (_ht - 50 - _topPadding) * 0.1,
                                    width: _wd * 0.2,
                                    child: FittedBox(
                                      child: Text(
                                        "(Optional)",
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize:
                                                (_ht - 50 - _topPadding) * 0.03,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.01,
                                  ),
                                  Container(
                                    width: _wd * 0.1,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      splashColor: Colors.red,
                                      onPressed: () {
                                        _displayDatePickerSubTask(context, i);
                                      },
                                      child: Icon(
                                        Icons.calendar_today_outlined,
                                      ),
                                      color: Colors.indigo[200],
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.01,
                                  ),
                                  Container(
                                    width: _wd * 0.1,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      splashColor: Colors.red,
                                      onPressed: () {
                                        _displayTimePickerSubTask(context, i);
                                      },
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                      ),
                                      color: Colors.indigo[200],
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: _wd * 0.03,
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
              Row(
                children: [
                  Container(
                    height: (_ht - 50 - _topPadding) * 0.05,
                    width: _wd * 0.35,
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),),),
                    child: RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: (_ht - 50 - _topPadding) * 0.05,
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
                    width: _wd * 0.3,
                    child: RaisedButton(
                      padding: EdgeInsets.zero,
                      color: Colors.indigo,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: (_ht - 50 - _topPadding) * 0.05,
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
                    width: _wd * 0.35,
                    height: (_ht - 50 - _topPadding) * 0.05,
                    child: RaisedButton(
                      padding: EdgeInsets.zero,
                      splashColor: Colors.red,
                      child: FittedBox(
                        child: Icon(
                          Icons.done,
                          size: 100,
                        ),
                      ),
                      color: Colors.green[600],
                      textColor: Colors.white,
                      onPressed: () {
                        if (_titleTextField.text != "") {
                          for (int i = 0; i < _titleControllers.length; i++) {
                            if (_titleControllers[i].text == "") {
                              return;
                            }
                          }
                          for (int i = 0; i < _titleControllers.length; i++) {
                            if (_titleControllers[i].text == "") {
                              return;
                            } else {
                              _subtaskEntries[i].heading =
                                  _titleControllers[i].text;
                            }
                          }

                          List<String> x;
                          if (_chosenDateString == "") {
                            x = ("Date Chosen (Default) : ${widget._today.day}/${widget._today.month}/${widget._today.year}"
                                    .split("/"))
                                .toList();
                          } else {
                            x = (_chosenDateString.split("/")).toList();
                          }

                          List<String> y;
                          if (_chosenTimeString == "") {
                            y = "Time Chosen (Default) :   ${widget._today.hour}:${widget._today.minute}"
                                .split(":")
                                .toList();
                          } else {
                            y = (_chosenTimeString.split(":"));
                          }
                          print(x);
                          if (x[0].substring(0, 1) == "D") {
                            widget._addReminder(
                              id: DateTime.now().toString(),
                              heading: _titleTextField.text,
                              subTasks: _subtaskEntries,
                              dueDate: DateTime.utc(
                                int.parse(x[2]),
                                int.parse(x[1]),
                                int.parse(x[0].split(":")[1]),
                              ),
                              dueTime: TimeOfDay(
                                  hour: int.parse(y[1]),
                                  minute: int.parse(y[2])),
                            );
                          } else {
                            widget._addReminder(
                              id: DateTime.now().toString(),
                              heading: _titleTextField.text,
                              subTasks: _subtaskEntries,
                              dueDate: DateTime.utc(
                                int.parse(x[2]),
                                int.parse(x[1]),
                                int.parse(x[0]),
                              ),
                              dueTime: TimeOfDay(
                                  hour: int.parse(y[1]),
                                  minute: int.parse(y[2])),
                            );
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reminder(
                                      widget._userReminders,
                                      widget._userTransactions,
                                      widget._userEntries,
                                    )),
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
