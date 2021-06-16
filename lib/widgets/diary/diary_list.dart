import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';

import '../../models/diary_entries.dart';
import './viewItem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryList extends StatefulWidget {
  final List<DiaryEntry> diaryEntries;
  final Function deletion;
  final Function editing;
  final DateTime afterDate;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  DiaryList(
    this.diaryEntries,
    this.deletion,
    this.editing,
    this.afterDate,
    this._userTransactions,
    this._userReminders,
  );

  @override
  _DiaryListState createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  @override
  Widget build(BuildContext context) {
    widget.diaryEntries.sort((a, b) {
      return a.date.isBefore(b.date) ? 1 : 0;
    });

    final List<DiaryEntry> _finalList = [];
    if (widget.afterDate == null) {
      for (int i = 0; i < widget.diaryEntries.length; i++) {
        _finalList.add(widget.diaryEntries[i]);
      }
    } else {
      for (int i = 0; i < widget.diaryEntries.length; i++) {
        if (widget.diaryEntries[i].date.isBefore(widget.afterDate) &&
            widget.diaryEntries[i].date
                .isAfter(widget.afterDate.subtract(Duration(days: 7)))) {
          _finalList.add(widget.diaryEntries[i]);
        }
      }
    }

    return LayoutBuilder(builder: (ctx, builderConstraint) {
      final _wd = builderConstraint.maxWidth;
      final _ht = builderConstraint.maxHeight;

      return Container(
        child: _finalList.isEmpty
            ? Stack(
                children: <Widget>[
                  Container(
                      height: _ht,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "images/empty_note.jpg",
                      )),
                  Container(
                    width: _ht,
                    height: _ht / 4,
                    alignment: Alignment.center,
                    child: Text(
                      "No Entries Are Entered For the displayed Week",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: _ht * 0.1,
                      child: FittedBox(
                        child: widget.afterDate == null
                            ? Text(
                                "Interval: All Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            : Text(
                                "Interval:  " +
                                    widget.afterDate
                                        .subtract(Duration(days: 7))
                                        .toString()
                                        .substring(
                                            0,
                                            widget.afterDate
                                                    .subtract(Duration(days: 7))
                                                    .toString()
                                                    .length -
                                                8) +
                                    " - " +
                                    widget.afterDate.toString().substring(0,
                                        widget.afterDate.toString().length - 8),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      )),
                  Container(
                    height: _ht * 0.9,
                    child: ListView.builder(
                      itemCount: _finalList.length,
                      itemBuilder: (function, i) {
                        return Container(
                          width: _wd,
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4.5),
                            shadowColor: Theme.of(context).primaryColor,
                            elevation: 8,
                            child: Container(
                              height: _ht * 0.2,
                              child: Row(
                                children: [
                                  Container(
                                    height: _ht * 0.2,
                                    width: (_wd - 16) * 0.33,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _ht * 0.2 * 0.05),
                                          width: (_wd - 16) * 0.33,
                                          height: _ht * 0.2 * 0.2,
                                          child: FittedBox(
                                            child: Text(
                                              DateFormat.yMMMMd()
                                                  .format(_finalList[i].date),
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 1000,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _ht * 0.2 * 0.05),
                                          width: (_wd - 16) * 0.33,
                                          height: _ht * 0.2 * 0.2,
                                          child: FittedBox(
                                            child: Text(
                                              DateFormat("EEEE")
                                                  .format(_finalList[i].date),
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 1000,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _ht * 0.2 * 0.05),
                                          width: (_wd - 16) * 0.33,
                                          height: _ht * 0.2 * 0.2,
                                          child: FittedBox(
                                            child: Text(
                                              _finalList[i]
                                                  .time
                                                  .format(context),
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 1000,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _ht * 0.2 * 0.05),
                                          width: (_wd - 16) * 0.33,
                                          height: _ht * 0.2 * 0.2,
                                          child: MaterialButton(
                                            padding: EdgeInsets.zero,
                                            minWidth: 0,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewEntry(
                                                    _finalList[i].id,
                                                    _finalList[i].heading,
                                                    _finalList[i].text,
                                                    _finalList[i].time,
                                                    _finalList[i].date,
                                                    _finalList,
                                                    widget._userTransactions,
                                                    widget._userReminders,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text("view"),
                                            color: Colors.green,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: _ht * 0.2,
                                    width: (_wd - 16) * 0.55,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: _ht * 0.2,
                                          child: _finalList[i].heading == null
                                              ? FittedBox(
                                                  child: Text(
                                                    _finalList[i].text.length >
                                                            30
                                                        ? _finalList[i]
                                                                .text
                                                                .substring(
                                                                    0, 30) +
                                                            "..."
                                                        : widget.diaryEntries[i]
                                                            .text
                                                            .substring(
                                                                0,
                                                                widget
                                                                    .diaryEntries[
                                                                        i]
                                                                    .text
                                                                    .length),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              : FittedBox(
                                                  child: Text(
                                                    _finalList[i].text.length >
                                                            30
                                                        ? _finalList[i]
                                                                .heading +
                                                            "\n" +
                                                            _finalList[i]
                                                                .text
                                                                .substring(
                                                                    0, 30) +
                                                            "..."
                                                        : _finalList[i]
                                                                .heading +
                                                            "\n" +
                                                            _finalList[i]
                                                                .text
                                                                .substring(
                                                                    0,
                                                                    widget
                                                                        .diaryEntries[
                                                                            i]
                                                                        .text
                                                                        .length),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: _ht * 0.2,
                                    width: (_wd - 16) * 0.1,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _ht * 0.2 * 0.05),
                                          height: _ht * 0.2 * 0.4,
                                          child: MaterialButton(
                                            padding: EdgeInsets.zero,
                                            minWidth: 0,
                                            onPressed: () {
                                              widget.editing(
                                                id: _finalList[i].id,
                                                heading: widget
                                                    .diaryEntries[i].heading,
                                                time: _finalList[i].time,
                                                title: _finalList[i].text,
                                                date: _finalList[i].date,
                                              );
                                            },
                                            child: Icon(
                                              Icons.edit,
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _ht * 0.2 * 0.05),
                                          height: _ht * 0.2 * 0.4,
                                          child: MaterialButton(
                                            padding: EdgeInsets.zero,
                                            minWidth: 0,
                                            onPressed: () {
                                              widget.deletion(_finalList[i].id);
                                            },
                                            child: Icon(
                                              Icons.delete_rounded,
                                            ),
                                            color: Colors.red,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
