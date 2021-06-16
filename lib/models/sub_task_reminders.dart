import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RemiderSubTasks {
  final String id;
  bool checkbox;
  String heading;
  DateTime dueDate;
  TimeOfDay dueTime;

  RemiderSubTasks({
    @required this.id,
    @required this.checkbox,
    @required this.heading,
    this.dueDate,
    this.dueTime,
  });
}
