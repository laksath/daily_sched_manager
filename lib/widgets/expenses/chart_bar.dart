import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day;
  final int money;
  final int totalMoney;
  ChartBar(this.day, this.money, this.totalMoney);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, builderConstraint) {
      final _ht = builderConstraint.maxHeight;
      final _wd = builderConstraint.maxWidth;
      return Column(
        children: [
          SizedBox(
            height: _ht * 0.04,
          ),
          Container(
            height: _ht * 0.1,
            child: FittedBox(child: Text(day)),
          ),
          SizedBox(
            height: _ht * 0.04,
          ),
          Container(
            height: _ht * 0.675,
            width: _wd * 0.25,
            child: Container(
              margin: money == 0
                  ? EdgeInsets.only(top: _ht * 0.675)
                  : EdgeInsets.only(
                      top: _ht * 0.675 - _ht * 0.675 * (money / totalMoney)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.redAccent,
                      Colors.blue,
                    ]),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          SizedBox(
            height: _ht * 0.02,
          ),
          Container(
            height: _ht * 0.1,
            child: FittedBox(
              child: Text(
                "₹$money",
              ),
            ),
          ),
          SizedBox(
            height: _ht * 0.02,
          ),
        ],
      );
    });
  }
}
