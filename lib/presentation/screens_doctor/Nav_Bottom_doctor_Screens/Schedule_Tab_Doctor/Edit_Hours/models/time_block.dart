import 'package:flutter/material.dart';

class TimeBlock {
  final TimeOfDay start;
  final TimeOfDay end;
  bool recurring;

  TimeBlock({
    required this.start,
    required this.end,
    this.recurring = true,
  });

  String get formatted =>
      "${_format(start)} - ${_format(end)}";

  String get tagLabel =>
      recurring ? "Recurring" : "This week only";

  String _format(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }
}
