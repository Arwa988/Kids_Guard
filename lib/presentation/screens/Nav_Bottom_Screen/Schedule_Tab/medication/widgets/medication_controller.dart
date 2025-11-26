import 'package:flutter/material.dart';
import 'medication_model.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';


class MedicationController extends ChangeNotifier {
  final List<Medication> _meds = [];
  final List<MedicationDose> _todayDoses = [];

  /// You can replace this with real API
  List<Medication> get allMeds => List.unmodifiable(_meds);

  List<MedicationDose> get todayDoses {
    // return copies sorted: untaken first, taken last
    List<MedicationDose> copy = List.from(_todayDoses);
    copy.sort((a, b) {
      if (a.taken == b.taken) return a.time.hour != b.time.hour ? a.time.hour - b.time.hour : a.time.minute - b.time.minute;
      return a.taken ? 1 : -1;
    });
    return copy;
  }

  void addMedication(Medication m) {
    _meds.add(m);
    // regenerate today's doses so UI updates
    generateTodaysDoses();
    notifyListeners();
  }

  void editMedication(String id, Medication updated) {
    final idx = _meds.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _meds[idx] = updated;
      generateTodaysDoses();
      notifyListeners();
    }
  }

  void deleteMedication(String id) {
    _meds.removeWhere((m) => m.id == id);
    generateTodaysDoses();
    notifyListeners();
  }

  /// doses for "today"
  void generateTodaysDoses([DateTime? forDate]) {
    final DateTime today = forDate ?? DateTime.now();
    final DateTime onlyDate = DateTime(today.year, today.month, today.day);
    _todayDoses.clear();

    for (var med in _meds) {
      if (_medAppliesOnDate(med, onlyDate)) {
        for (var t in med.times) {
          final dateTime = DateTime(
              onlyDate.year,
              onlyDate.month,
              onlyDate.day, t.hour, t.minute
          );
          final id = '${med.id}|${DateFormat('yyyy-MM-dd').format(onlyDate)}|${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
          _todayDoses.add(MedicationDose(
            id: id,
            medId: med.id,
            medName: med.name,
            dosage: med.dosage,
            date: onlyDate,
            time: t,
          ));
        }
      }
    }
    notifyListeners();
  }

  bool _medAppliesOnDate(Medication med, DateTime date) {
    // FrequencyType.daily => every day
    if (med.frequencyType == FrequencyType.daily) return true;

    if (med.frequencyType == FrequencyType.specificDays) {
      // DateTime.weekday: Mon=1..Sun=7 -> med.specificDays uses same encoding
      return med.specificDays.contains(date.weekday);
    }

    if (med.frequencyType == FrequencyType.everyXDays) {
      final diffDays = date.difference(DateTime(date.year, date.month, date.day)).inDays; // always 0
      // without a default start date we assume everyXDays means repeating from the date the medication was added
      // We'll assume meds are effective since the day they were added and we can't access that here; so for simplicity, return true.
      return true;
    }
    return false;
  }

  void toggleTaken(String doseId) {
    final idx = _todayDoses.indexWhere((d) => d.id == doseId);
    if (idx >= 0) {
      final dose = _todayDoses[idx];
      dose.taken = !dose.taken;
      dose.takenAt = dose.taken ? DateTime.now() : null;
      notifyListeners();
    }
  }

  // taken with reason (late/on-time) --> returns bool for onTime
  bool markTakenWithCheck(String doseId) {
    final idx = _todayDoses.indexWhere((d) => d.id == doseId);
    if (idx < 0) return false;
    final dose = _todayDoses[idx];
    final scheduled = DateTime(
        dose.date.year,
        dose.date.month,
        dose.date.day,
        dose.time.hour,
        dose.time.minute);
    final now = DateTime.now();
    final diffInMinutes = now.difference(scheduled).inMinutes;
    final onTime = diffInMinutes <= 30 && diffInMinutes >= -60; // 60m early or 30m late considered on-time
    dose.taken = true;
    dose.takenAt = now;
    notifyListeners();
    return onTime;
  }

  Medication? getMedicationById(String id) =>
      _meds.firstWhereOrNull((m) => m.id == id);
}
