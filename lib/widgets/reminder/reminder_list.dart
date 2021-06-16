import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/reminder/viewReminder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReminderList extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  final int listLenType;
  final int _deleteMode;
  final Function deleteReminder;
  ReminderList(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
    this.listLenType,
    this._deleteMode,
    this.deleteReminder,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, builderConstraint) {
      final _wd = builderConstraint.maxWidth;
      final _ht = builderConstraint.maxHeight;
      List<ReminderEntry> _finalList = [];

      _userReminders.sort((a, b) {
        return a.dueDate.isBefore(b.dueDate) ? 1 : 0;
      });

      if (listLenType == 1) {
        for (int i = 0; i < _userReminders.length; i++) {
          _finalList.add(_userReminders[i]);
        }
      } else {
        for (int i = 0; i < _userReminders.length; i++) {
          if (_userReminders[i].dueDate.isBefore(
                    DateTime.utc(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ).add(
                      Duration(days: 7),
                    ),
                  ) &&
              _userReminders[i].dueDate.isAfter(
                    DateTime.utc(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ).subtract(
                      Duration(days: 1),
                    ),
                  )) {
            _finalList.add(_userReminders[i]);
          }
        }
      }
      return Column(
        children: [
          Container(
            height: _ht,
            width: _wd,
            child: _finalList.length == 0
                ? Container(
                    height: _ht,
                    width: _wd * 5 / 6,
                    margin: EdgeInsets.only(
                      left: _wd / 12,
                      right: _wd / 12,
                    ),
                    child: FittedBox(
                      child: Text(
                        "Data Not Found!\nIf Data is Present,\nTry Refreshing by\ntapping the\nCurrent Week\nor\nAll Reminders Button",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _finalList.length,
                    itemBuilder: (function, i) {
                      return Container(
                        width: _wd - 16,
                        height: _ht * 0.2,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            child: Card(
                              color: _deleteMode == 0
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.red,
                              margin: EdgeInsets.zero,
                              shadowColor: Theme.of(context).primaryColor,
                              elevation: _deleteMode == 0 ? 0 : 8,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (_wd - 16) * 0.55,
                                    height: _ht * 0.2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: _ht * 0.2 * 0.6,
                                          width: (_wd - 16) * 0.5,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              "${_finalList[i].heading}",
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
                                          height: _ht * 0.2 * 0.4,
                                          width: (_wd - 16) * 0.5,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              "SubTask Entries: ${_finalList[i].subTasks.length}",
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 1000,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: (_wd - 16) * 0.05,
                                    height: _ht * 0.2,
                                  ),
                                  Container(
                                    width: (_wd - 16) * 0.4,
                                    height: _ht * 0.2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: _ht * 0.1,
                                          width: (_wd - 16) * 0.5,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              "${DateFormat.yMMMMd().format(_finalList[i].dueDate)}",
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 1000,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: _ht * 0.1,
                                          width: (_wd - 16) * 0.5,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              (_finalList[i].dueTime.minute <
                                                      10)
                                                  ? "Due : ${_finalList[i].dueTime.hour}:0${_finalList[i].dueTime.minute}"
                                                  : "Due : ${_finalList[i].dueTime.hour}:${_finalList[i].dueTime.minute}",
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 1000,
                                                ),
                                              ),
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
                          onPressed: () {
                            if (_deleteMode == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewReminder(
                                    _userEntries,
                                    _userTransactions,
                                    _userReminders,
                                    listLenType,
                                    _deleteMode,
                                    deleteReminder,
                                    _finalList,
                                    i,
                                  ),
                                ),
                              );
                            } else {
                              deleteReminder(_finalList[i].id);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
