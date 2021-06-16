import 'package:daily_schedule_manager/models/sub_task_reminders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReminderEntry {
  final String id;
  final String heading;
  final List<RemiderSubTasks> subTasks;
  final DateTime dueDate;
  final TimeOfDay dueTime;

  ReminderEntry(
      {@required this.id,
      @required this.heading,
      @required this.subTasks,
      @required this.dueDate,
      @required this.dueTime});
}
