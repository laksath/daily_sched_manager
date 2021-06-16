import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/reminder/newReminder.dart';
import 'package:flutter/material.dart';

import '../../postauth.dart';

class BottomBarReminder extends StatelessWidget {
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  final Function addReminder;
  final Function deleteReminderPermission;
  final Function cancelDelete;
  BottomBarReminder(
    this._userEntries,
    this._userTransactions,
    this._userReminders,
    this.addReminder,
    this.deleteReminderPermission,
    this.cancelDelete,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, buildContext) {
      final _ht = buildContext.maxHeight;
      return Container(
        height: _ht,
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: _ht,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: Colors.black,
                        size: _ht * 0.7,
                      ),
                      Container(
                        height: _ht * 0.3,
                        child: FittedBox(
                          child: Text("Cancel Delete"),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    cancelDelete();
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
                      Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.black,
                        size: _ht * 0.7,
                      ),
                      Container(
                        height: _ht * 0.3,
                        child: FittedBox(
                          child: Text(
                            "Delete Item",
                            style: TextStyle(
                              fontSize: 100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    deleteReminderPermission();
                  },
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: _ht,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  color: Colors.black.withOpacity(0.3),
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
                        builder: (context) => NewReminder(
                            _userEntries,
                            _userTransactions,
                            _userReminders,
                            addReminder,
                            DateTime.now()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
