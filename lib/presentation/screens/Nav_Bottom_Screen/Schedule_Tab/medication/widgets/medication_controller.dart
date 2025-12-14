// File: lib/presentation/screens/Nav_Bottom_Screen/Schedule_Tab/medication/widgets/medication_controller.dart

import 'package:flutter/material.dart';
import '../../../../../../core/constants/services/medication_service.dart';

class MedicationController extends ChangeNotifier {
  final MedicationService _medicationService = MedicationService();
  List<Medication> _meds = [];
  List<MedicationDose> _todayDoses = [];

  Stream<List<Medication>> get medicationsStream => 
      _medicationService.getMedicationsStream();
  
  Stream<List<MedicationDose>> get todayDosesStream => 
      _medicationService.getTodayDosesStream();

  List<Medication> get allMeds => List.unmodifiable(_meds);
  
  List<MedicationDose> get todayDoses {
    List<MedicationDose> copy = List.from(_todayDoses);
    copy.sort((a, b) {
      if (a.taken == b.taken) {
        return a.time.hour != b.time.hour 
            ? a.time.hour - b.time.hour 
            : a.time.minute - b.time.minute;
      }
      return a.taken ? 1 : -1;
    });
    return copy;
  }

  void initializeStreams() {
    medicationsStream.listen((medications) {
      _meds = medications;
      notifyListeners();
    });

    todayDosesStream.listen((doses) {
      _todayDoses = doses;
      notifyListeners();
    });
  }

  Future<void> addMedication(Medication medication) async {
    try {
      await _medicationService.addMedication(medication);
    } catch (e) {
      print('❌ Error in controller adding medication: $e');
      rethrow;
    }
  }

  Future<void> editMedication(String id, Medication updated) async {
    try {
      await _medicationService.updateMedication(updated);
    } catch (e) {
      print('❌ Error in controller updating medication: $e');
      rethrow;
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _medicationService.deleteMedication(id);
    } catch (e) {
      print('❌ Error in controller deleting medication: $e');
      rethrow;
    }
  }

  Future<void> toggleTaken(String doseId) async {
    try {
      final dose = _todayDoses.firstWhere((d) => d.id == doseId);
      await _medicationService.updateDoseStatus(doseId, !dose.taken);
    } catch (e) {
      print('❌ Error toggling dose: $e');
      rethrow;
    }
  }

  Future<bool> markTakenWithCheck(String doseId) async {
    try {
      final idx = _todayDoses.indexWhere((d) => d.id == doseId);
      if (idx < 0) return false;
      
      final dose = _todayDoses[idx];
      final scheduled = DateTime(
        dose.date.year,
        dose.date.month,
        dose.date.day,
        dose.time.hour,
        dose.time.minute,
      );
      final now = DateTime.now();
      final diffInMinutes = now.difference(scheduled).inMinutes;
      final onTime = diffInMinutes <= 30 && diffInMinutes >= -60;
      
      await _medicationService.updateDoseStatus(doseId, true);
      return onTime;
    } catch (e) {
      print('❌ Error marking dose with check: $e');
      return false;
    }
  }


  Medication? getMedicationById(String id) {
    try {
      return _meds.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}