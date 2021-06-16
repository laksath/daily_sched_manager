import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DiaryEntry {
  final String id;
  final String heading;
  final String text;
  final DateTime date;
  final TimeOfDay time;

  DiaryEntry(
      {@required this.id,
      this.heading,
      @required this.text,
      @required this.time,
      @required this.date});
}
