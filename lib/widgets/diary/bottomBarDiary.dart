import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';

import '../../postauth.dart';
import '../../models/diary_entries.dart';
import './newEntry.dart';
import 'package:flutter/material.dart';

class BottomBarDiary extends StatelessWidget {
  final Function dayChanger;
  final Function add;
  final List<DiaryEntry> diaryEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;

  BottomBarDiary(
    this.dayChanger,
    this.add,
    this._userTransactions,
    this.diaryEntries,
    this._userReminders,
  );

  void _displayDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then(
      (value) {
        if (value == null) return;
        dayChanger(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, buildContext) {
      final _ht = buildContext.maxHeight;
      return Container(
        height: _ht,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: _ht,
                child: FlatButton(
                  color: Colors.black.withOpacity(0.3),
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: _ht,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewEntry(
                          add,
                          diaryEntries,
                          _userTransactions,
                          _userReminders,
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
                height: _ht,
                child: FlatButton(
                  color: Colors.black.withOpacity(0.3),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        height: _ht * 0.25 / 2,
                      ),
                      Container(
                        height: _ht * 0.25,
                        child: FittedBox(
                          child: Text(
                            "View",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: _ht * 0.25,
                        child: FittedBox(
                          child: Text(
                            "All",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: _ht * 0.25,
                        child: FittedBox(
                          child: Text(
                            "Entries",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: _ht * 0.25 / 2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    dayChanger(null);
                  },
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: _ht,
                child: FlatButton(
                  color: Colors.black.withOpacity(0.3),
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: _ht,
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
              child: Container(
                child: FlatButton(
                  color: Colors.black.withOpacity(0.3),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        child: Icon(
                          Icons.calendar_today_sharp,
                          color: Colors.black,
                          size: _ht * 0.55,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: _ht * 0.25),
                        child: Column(
                          children: [
                            Container(
                              height: _ht * 0.25,
                              child: FittedBox(
                                child: Text(
                                  "Choose",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              height: _ht * 0.25,
                              child: FittedBox(
                                child: Text(
                                  "Custom",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              height: _ht * 0.25,
                              child: FittedBox(
                                child: Text(
                                  "Week",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => {_displayDatePicker(context)},
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: FlatButton(
                color: Colors.black.withOpacity(0.3),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      child: Icon(
                        Icons.refresh_sharp,
                        color: Colors.black45,
                        size: _ht * 0.8,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _ht * 0.25),
                      child: Column(
                        children: [
                          Container(
                            height: _ht * 0.25,
                            child: FittedBox(
                              child: Text(
                                "Current",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            height: _ht * 0.25,
                            child: FittedBox(
                              child: Text(
                                "Week",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            height: _ht * 0.25,
                            child: FittedBox(
                              child: Text(
                                "Diary",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  dayChanger(DateTime.now());
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
