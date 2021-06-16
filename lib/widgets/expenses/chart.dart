import 'package:flutter/material.dart';
import 'package:daily_schedule_manager/models/transactions.dart';
import './chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transactions> weeklyTransactions;
  final int empty;
  final DateTime dateConst;
  Chart(this.weeklyTransactions, this.dateConst, this.empty);
  List<Map<String, Object>> get groupedTransactionVals {
    var _retvar = List.generate(7, (index) {
      var weekday;
      if (dateConst == null) {
        weekday = DateTime.now().subtract(
          Duration(days: index),
        );
      } else {
        weekday = dateConst.subtract(
          Duration(days: index),
        );
      }

      var totalSum = 0;
      for (int i = 0; i < weeklyTransactions.length; i++) {
        if (weeklyTransactions[i].date.day == weekday.day &&
            weeklyTransactions[i].date.month == weekday.month &&
            weeklyTransactions[i].date.year == weekday.year) {
          totalSum += weeklyTransactions[i].money;
        }
      }
      return {
        "day": DateFormat.E().format(weekday),
        "money": totalSum,
        "date": weekday,
      };
    }).reversed.toList();

    return _retvar;
  }

  int get totalMoney {
    int s = 0;
    for (int i = 0; i < weeklyTransactions.length; i++) {
      s += weeklyTransactions[i].money;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, builderConstraint) {
      final _ht = builderConstraint.maxHeight;
      return Container(
        // color: Colors.green,
        padding: EdgeInsets.only(
          top: _ht * 0.05,
          left: 5.0,
          right: 5,
          bottom: _ht * 0.05,
        ),
        child: Column(
          children: [
            Container(
              height: _ht * 0.072,
              child: FittedBox(
                child: Text(
                  "${DateFormat.d().format(groupedTransactionVals[0]["date"])}/${DateFormat.M().format(groupedTransactionVals[0]["date"])}/${DateFormat.y().format(groupedTransactionVals[0]["date"])} to ${DateFormat.d().format(groupedTransactionVals[6]["date"])}/${DateFormat.M().format(groupedTransactionVals[6]["date"])}/${DateFormat.y().format(groupedTransactionVals[6]["date"])}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: _ht * 0.828,
              child: Card(
                elevation: 10,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: groupedTransactionVals.map((data) {
                      return Flexible(
                        fit: FlexFit.loose,
                        child: ChartBar(data["day"], data["money"], totalMoney),
                      );
                    }).toList()),
              ),
            ),
          ],
        ),
      );
    });
  }
}
