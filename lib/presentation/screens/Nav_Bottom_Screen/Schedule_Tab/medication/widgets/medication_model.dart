import 'package:flutter/material.dart';

enum FrequencyType { daily, specificDays, everyXDays }

class Medication {
  final String id;
  String name;
  String dosage;
  FrequencyType frequencyType;
  List<int> specificDays;
  int? everyXDays;
  List<TimeOfDay> times;
  DateTime? createdAt;
  DateTime? updatedAt;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    this.frequencyType = FrequencyType.daily,
    List<int>? specificDays,
    this.everyXDays,
    List<TimeOfDay>? times,
    this.createdAt,
    this.updatedAt,
  })  : specificDays = specificDays ?? [],
        times = times ?? [const TimeOfDay(hour: 8, minute: 0)];

  String timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay stringToTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class MedicationDose {
  final String id;
  final String medId;
  final String medName;
  final String dosage;
  final DateTime date;
  final TimeOfDay time;
  bool taken;
  DateTime? takenAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  MedicationDose({
    required this.id,
    required this.medId,
    required this.medName,
    required this.dosage,
    required this.date,
    required this.time,
    this.taken = false,
    this.takenAt,
    this.createdAt,
    this.updatedAt,
  });


  bool get isLate {
    if (taken) return false;
    
    final now = DateTime.now();
    final scheduledTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    
    return now.isAfter(scheduledTime.add(const Duration(minutes: 30)));
  }

  bool get isUpcoming {
    if (taken) return false;
    
    final now = DateTime.now();
    final scheduledTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    
    final difference = scheduledTime.difference(now);
    return difference.inMinutes <= 30 && difference.inMinutes > 0;
  }
}