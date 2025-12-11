import 'package:flutter/material.dart';

enum FrequencyType { daily, specificDays, everyXDays }

class Medication {
  final String id;
  String name;
  String dosage; // free text
  FrequencyType frequencyType;
  /// if frequencyType == specificDays, values 1..7 (Mon..Sun)
  List<int> specificDays;
  /// if frequencyType == everyXDays, value >=2
  int? everyXDays;
  /// scheduled times in the day
  List<TimeOfDay> times;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    this.frequencyType = FrequencyType.daily,
    List<int>? specificDays,
    this.everyXDays,
    List<TimeOfDay>? times,
  })  : specificDays = specificDays ?? [],
        times = times ?? [const TimeOfDay(hour: 8, minute: 0)];
}

class MedicationDose {
  final String id; // unique id for dose (medId|yyyy-MM-dd|HH:mm)
  final String medId;
  final String medName;
  final String dosage;
  final DateTime date; // the date this dose is scheduled for
  final TimeOfDay time;
  bool taken;
  DateTime? takenAt;

  MedicationDose({
    required this.id,
    required this.medId,
    required this.medName,
    required this.dosage,
    required this.date,
    required this.time,
    this.taken = false,
    this.takenAt,
  });
}
