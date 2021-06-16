import 'package:daily_schedule_manager/postauth.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final Function weekChartFn;
  final Function add;
  final Function allTxns;
  final int weekly;
  BottomBar(this.weekChartFn, this.add, this.allTxns, this.weekly);

  void _displayDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      weekChartFn(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime _d = DateTime.now();
    return LayoutBuilder(builder: (ctx, buildContext) {
      final _ht = buildContext.maxHeight;
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: _ht,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  color: Colors.black.withOpacity(0.3),
                  child: Container(
                    margin: EdgeInsets.only(top: _ht * 0.2),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          height: _ht * 0.2,
                          child: FittedBox(
                            child: Text(
                              "VIEW",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: _ht * 0.2,
                          child: FittedBox(
                            child: Text(
                              weekly == -1 ? "ALL" : "RECENT",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: _ht * 0.2,
                          child: FittedBox(
                            child: Text(
                              "TRANSACTONS",
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
                  onPressed: () {
                    allTxns();
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
                    size: _ht * 0.7,
                  ),
                  onPressed: () {
                    add();
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
                    size: _ht * 0.7,
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
                          size: _ht * 0.45,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: _ht * 0.4),
                        child: Column(
                          children: [
                            Container(
                              height: _ht * 0.2,
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
                              height: _ht * 0.2,
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
                        color: Colors.black,
                        size: _ht * 0.5,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _ht * 0.4),
                      child: Column(
                        children: [
                          Container(
                            height: _ht * 0.2,
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
                            height: _ht * 0.2,
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
                onPressed: () {
                  weekChartFn(_d.subtract(Duration(
                    hours: _d.hour,
                    minutes: _d.minute,
                    seconds: _d.second,
                    milliseconds: _d.millisecond,
                    microseconds: _d.microsecond,
                  )));
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
