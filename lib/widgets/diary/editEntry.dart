import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/diary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../postauth.dart';

class EditEntry extends StatelessWidget {
  final String id;
  final String heading;
  final String title;
  final TimeOfDay time;
  final DateTime date;
  final List<DiaryEntry> diaryEntries;
  final Function addData;
  final Function deletion;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  EditEntry(
    this.id,
    this.heading,
    this.title,
    this.time,
    this.date,
    this.diaryEntries,
    this.addData,
    this.deletion,
    this._userReminders,
    this._userTransactions,
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
        addData,
        deletion,
        _userReminders,
        _userTransactions,
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
  final Function addData;
  final Function deletion;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  DiaryHomePage(
    this.id,
    this.heading,
    this.title,
    this.time,
    this.date,
    this.diaryEntries,
    this.addData,
    this.deletion,
    this._userReminders,
    this._userTransactions,
  );

  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  DateTime _chosenDate;
  TimeOfDay _chosenTime;

  void _displayDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: widget.date,
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
      initialTime: widget.time,
    ).then((value) {
      if (value == null) return;
      setState(() {
        _chosenTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _titleTextField = TextEditingController(text: widget.heading);
    final _contentTextField = TextEditingController(text: widget.title);
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
                          _chosenTime == null
                              ? widget.time.minute < 10
                                  ? "Time :  ${widget.time.hour}:0${widget.time.minute}"
                                  : "Time :  ${widget.time.hour}:${widget.time.minute}"
                              : _chosenTime.minute < 10
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
                          _chosenDate == null
                              ? "Date :  ${DateFormat.yMMMMd().format(widget.date)} ${DateFormat("EEEE").format(widget.date)}"
                              : "Date :  ${DateFormat.yMMMMd().format(_chosenDate)} ${DateFormat("EEEE").format(_chosenDate)}",
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
                    width: (_wd - 6),
                    child: Container(
                      alignment: Alignment.center,
                      height: (_ht) * 0.17 * 0.3,
                      child: TextField(
                        controller: _titleTextField,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (_ht) * 0.17 * 0.25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Times New Roman",
                          color: Colors.blue,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Heading',
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.3, style: BorderStyle.solid),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: (_ht) * 0.75 - _topPadding - _keyboard,
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
                          widget.deletion(widget.id);
                          widget.addData(
                            id: DateTime.now().toString(),
                            heading: _titleTextField.text,
                            title: _contentTextField.text,
                            date:
                                _chosenDate == null ? widget.date : _chosenDate,
                            time:
                                _chosenTime == null ? widget.time : _chosenTime,
                          );
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
