import 'package:daily_schedule_manager/models/diary_entries.dart';
import 'package:daily_schedule_manager/models/reminider_entries.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:daily_schedule_manager/widgets/diary.dart';
import 'package:daily_schedule_manager/widgets/expense.dart';
import 'package:daily_schedule_manager/widgets/reminder.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../logininfo.dart' as logininf;
import '../postauth.dart';

class DrawerClass extends StatelessWidget {
  final _ht;
  final _wd;
  final _topPadding;
  final List<DiaryEntry> _userEntries;
  final List<Transactions> _userTransactions;
  final List<ReminderEntry> _userReminders;
  DrawerClass(
    this._ht,
    this._wd,
    this._topPadding,
    this._userTransactions,
    this._userEntries,
    this._userReminders,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _wd * 0.85,
      child: Drawer(
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
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: _ht * 0.05),
                  padding: EdgeInsets.zero,
                  height: _ht * 0.3,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(logininf.user.photoURL),
                              radius: (_ht) * 0.1 - _topPadding * 0.5,
                            ),
                          ),
                          Container(
                            height: (_ht) * 0.1,
                            width: _wd * 0.8,
                            margin:
                                EdgeInsets.symmetric(horizontal: _wd * 0.025),
                            child: FittedBox(
                              child: Text(
                                logininf.user.displayName,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: Colors.white),
                    ),
                  ),
                  height: _ht * 0.1,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Container(
                          width: _wd * 0.1,
                          child: Icon(
                            Icons.home,
                          ),
                        ),
                        Container(
                          width: _wd * 0.75,
                          child: Text(
                            'Home',
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
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
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.white),
                    ),
                  ),
                  height: _ht * 0.1,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Container(
                          width: _wd * 0.1,
                          child: Icon(
                            Icons.notifications_sharp,
                          ),
                        ),
                        Container(
                          width: _wd * 0.75,
                          child: Text(
                            'Reminder',
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Reminder(
                            _userReminders,
                            _userTransactions,
                            _userEntries,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.white),
                    ),
                  ),
                  height: _ht * 0.1,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Container(
                          width: _wd * 0.1,
                          child: Icon(
                            Icons.monetization_on,
                          ),
                        ),
                        Container(
                          width: _wd * 0.75,
                          child: Text(
                            'Expenses',
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseManage(
                            _userEntries,
                            _userTransactions,
                            _userReminders,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.white),
                    ),
                  ),
                  height: _ht * 0.1,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Container(
                          width: _wd * 0.1,
                          child: Icon(
                            Icons.note_add,
                          ),
                        ),
                        Container(
                          width: _wd * 0.75,
                          child: Text(
                            'Diary',
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
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
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color: Colors.white),
                      bottom: BorderSide(width: 0.5, color: Colors.white),
                    ),
                  ),
                  height: _ht * 0.1,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Container(
                          width: _wd * 0.1,
                          child: Icon(
                            Icons.exit_to_app,
                          ),
                        ),
                        Container(
                          width: _wd * 0.75,
                          child: Text(
                            'Logout',
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      logininf.gSignIn.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPageWidget()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
