import 'package:flutter/foundation.dart';

class Transactions {
  final String id;
  final String text;
  final int money;
  final DateTime date;

  Transactions(
      {@required this.id,
      @required this.text,
      @required this.money,
      @required this.date});
}
