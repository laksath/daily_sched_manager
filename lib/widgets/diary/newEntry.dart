import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/diary_entries.dart';
import '../diary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../postauth.dart';

class NewEntry extends StatelessWidget {
  final Function addData;
  final List<DiaryEntry> diaryEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  NewEntry(
    this.addData,
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
        addData,
        diaryEntries,
        _userTransactions,
        _userReminders,
      ),
    );
  }
}

class DiaryHomePage extends StatefulWidget {
  final Function addData;
  final List<DiaryEntry> diaryEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  DiaryHomePage(
    this.addData,
    this.diaryEntries,
    this._userTransactions,
    this._userReminders,
  );

  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  DateTime _chosenDate = DateTime.now();
  TimeOfDay _chosenTime = TimeOfDay(
    hour: int.parse(DateFormat.Hm().format(DateTime.now()).substring(0, 2)),
    minute: int.parse(DateFormat.Hm().format(DateTime.now()).substring(3)),
  );

  final _titleTextField = TextEditingController();
  final _contentTextField = TextEditingController();

  void _displayDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _chosenDate = value;
      });
    });
  }

  void _displayTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: _chosenTime.hour, minute: _chosenTime.minute),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _chosenTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _wd = MediaQuery.of(context).size.width;
    final _keyboard = MediaQuery.of(context).viewInsets.bottom;
    final _topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        color: Colors.white12,
        child: Column(
          children: [
            Container(
              height: (_ht) * 0.17,
              margin: EdgeInsets.only(
                left: 3,
                right: 3,
                top: _topPadding,
              ),
              child: Column(
                children: [
                  Container(
                    width: (_wd - 6),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: (_ht) * 0.17 * 0.15,
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
                    width: (_wd - 6),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: (_ht) * 0.17 * 0.15,
                      width: (_wd - 6) * 0.7,
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
                  ),
                  Container(
                    height: (_ht) * 0.17 * 0.7,
                    width: _wd - 6,
                    child: Row(
                      children: [
                        Container(
                          width: _wd - 6,
                          child: TextField(
                            controller: _titleTextField,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: (_ht) * 0.17 * 0.3,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo,
                              ),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Heading',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: (_ht) * 0.75 - _topPadding - _keyboard,
                width: (_wd - 6),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(
                    left: _wd * 0.05, right: _wd * 0.05, top: (_ht) * 0.01),
                child: TextField(
                  controller: _contentTextField,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Content',
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ),
            ),
            Container(
              height: (_ht) * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: (_ht) * 0.08,
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
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: (_ht) * 0.08,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          "Ok",
                          style: TextStyle(
                            color: Colors.indigo[600],
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: FlatButton(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.indigo[300],
                              size: (_ht) * 0.05,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _displayDatePicker(context);
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
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
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: FlatButton(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            child: Icon(
                              Icons.watch_later_outlined,
                              color: Colors.indigo[300],
                              size: (_ht) * 0.05,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _displayTimePicker(context);
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: _ht,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          child: Icon(
                            Icons.done,
                            color: Colors.indigo[300],
                            size: (_ht) * 0.05,
                          ),
                        ),
                        onPressed: () {
                          if (_contentTextField.text == "") {
                            return null;
                          } else {
                            widget.addData(
                              id: DateTime.now().toString(),
                              title: _contentTextField.text,
                              heading: _titleTextField.text,
                              date: _chosenDate,
                              time: _chosenTime,
                            );
                          }
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
