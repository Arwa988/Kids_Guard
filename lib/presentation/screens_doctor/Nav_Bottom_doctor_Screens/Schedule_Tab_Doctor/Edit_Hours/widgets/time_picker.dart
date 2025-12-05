import 'package:flutter/material.dart';
import '../models/time_block.dart';

Future<TimeBlock?> showTimeRangePicker(BuildContext context) async {
  TimeOfDay? start = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (start == null) return null;

  TimeOfDay? end = await showTimePicker(
    context: context,
    initialTime: start,
  );
  if (end == null) return null;

  return TimeBlock(start: start, end: end);
}
