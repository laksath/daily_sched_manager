import 'package:daily_schedule_manager/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deletion;
  final Function editing;
  TransactionList({
    this.transactions,
    this.deletion,
    this.editing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, builderConstraint) {
      final _wd = builderConstraint.maxWidth;
      final _ht = builderConstraint.maxHeight;
      return Container(
        child: transactions.isEmpty
            ? Stack(
                children: <Widget>[
                  Container(
                    height: _ht,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "images/sleeping_panda.jpg",
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: _ht,
                    height: _ht / 4,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: _ht / 4,
                    ),
                    child: Text(
                      "No Transaction Data of this Week",
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
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (function, i) {
                  return Container(
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 5,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              height: _ht * 0.15 * 0.7,
                              width: (_wd - 16) * 0.2,
                              margin: EdgeInsets.only(left: (_wd - 16) * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: (_wd - 16) * 0.2 * 0.06),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FittedBox(
                                child: Text(
                                  "₹${transactions[i].money}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: (_wd - 16) * 0.02),
                              height: _ht * 0.15 * 0.7,
                              width: (_wd - 16) * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      transactions[i].text,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: _ht * 0.15 * 0.7 * 0.39,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      DateFormat.yMMMMd()
                                          .add_jm()
                                          .format(transactions[i].date),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: (_wd - 16) * 0.1),
                              height: _ht * 0.15,
                              child: Row(
                                children: [
                                  Container(
                                    width: (_wd - 16) * 0.3 * 0.25,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      onPressed: () {
                                        editing(
                                          id: transactions[i].id,
                                          money: transactions[i].money,
                                          title: transactions[i].text,
                                          date: transactions[i].date,
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: (_wd - 16) * 0.01),
                                    width: (_wd - 16) * 0.3 * 0.25,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 0,
                                      onPressed: () {
                                        deletion(transactions[i].id);
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
      );
    });
  }
}
