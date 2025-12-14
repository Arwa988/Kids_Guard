// File: lib/core/services/medication_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final String id;
  final String medId;
  final String medName;
  final String dosage;
  final DateTime date;
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
class MedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  CollectionReference get _medicationsCollection =>
      _firestore.collection('medication_guardian')
          .doc(_auth.currentUser?.uid ?? 'default_user')
          .collection('medications');
  
  CollectionReference get _dosesCollection =>
      _firestore.collection('medication_guardian')
          .doc(_auth.currentUser?.uid ?? 'default_user')
          .collection('doses');
  
  Future<void> addMedication(Medication medication) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }
      
      await _medicationsCollection.doc(medication.id).set({
        'id': medication.id,
        'name': medication.name,
        'dosage': medication.dosage,
        'frequencyType': medication.frequencyType.index,
        'specificDays': medication.specificDays,
        'everyXDays': medication.everyXDays,
        'times': medication.times.map((time) => {
          'hour': time.hour,
          'minute': time.minute,
        }).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'userId': userId,
      });
      
      await _generateDosesForMedication(medication);
    } catch (e) {
      print('❌ Error adding medication: $e');
      throw e;
    }
  }
  
  Future<void> updateMedication(Medication medication) async {
    try {
      await _medicationsCollection.doc(medication.id).update({
        'name': medication.name,
        'dosage': medication.dosage,
        'frequencyType': medication.frequencyType.index,
        'specificDays': medication.specificDays,
        'everyXDays': medication.everyXDays,
        'times': medication.times.map((time) => {
          'hour': time.hour,
          'minute': time.minute,
        }).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await _deleteDosesForMedication(medication.id);
      await _generateDosesForMedication(medication);
    } catch (e) {
      print('❌ Error updating medication: $e');
      throw e;
    }
  }
  
  Future<void> deleteMedication(String medicationId) async {
    try {
      await _medicationsCollection.doc(medicationId).delete();
      await _deleteDosesForMedication(medicationId);
    } catch (e) {
      print('❌ Error deleting medication: $e');
      throw e;
    }
  }
  
  Stream<List<Medication>> getMedicationsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    
    return _medicationsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Medication(
          id: data['id'],
          name: data['name'],
          dosage: data['dosage'],
          frequencyType: FrequencyType.values[data['frequencyType']],
          specificDays: List<int>.from(data['specificDays'] ?? []),
          everyXDays: data['everyXDays'],
          times: (data['times'] as List)
              .map((time) => TimeOfDay(
                    hour: time['hour'],
                    minute: time['minute'],
                  ))
              .toList(),
        );
      }).toList();
    });
  }
  
  Stream<List<MedicationDose>> getTodayDosesStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _dosesCollection
        .where('date', isGreaterThanOrEqualTo: today)
        .where('date', isLessThan: tomorrow)
        .orderBy('date')
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timeData = data['time'] as Map<String, dynamic>;
        
        return MedicationDose(
          id: data['id'],
          medId: data['medId'],
          medName: data['medName'],
          dosage: data['dosage'],
          date: (data['date'] as Timestamp).toDate(),
          time: TimeOfDay(
            hour: timeData['hour'],
            minute: timeData['minute'],
          ),
          taken: data['taken'] ?? false,
          takenAt: data['takenAt'] != null
              ? (data['takenAt'] as Timestamp).toDate()
              : null,
        );
      }).toList();
    });
  }

  Future<void> updateDoseStatus(String doseId, bool taken) async {
    try {
      await _dosesCollection.doc(doseId).update({
        'taken': taken,
        'takenAt': taken ? FieldValue.serverTimestamp() : null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ Error updating dose status: $e');
      throw e;
    }
  }
  
  Future<void> _generateDosesForMedication(Medication medication) async {
    const daysToGenerate = 30;
    
    for (int i = 0; i < daysToGenerate; i++) {
      final date = DateTime.now().add(Duration(days: i));
      
      if (_medAppliesOnDate(medication, date)) {
        for (var time in medication.times) {
          final doseId = '${medication.id}|${_formatDate(date)}|${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          
          await _dosesCollection.doc(doseId).set({
            'id': doseId,
            'medId': medication.id,
            'medName': medication.name,
            'dosage': medication.dosage,
            'date': Timestamp.fromDate(date),
            'time': {
              'hour': time.hour,
              'minute': time.minute,
            },
            'taken': false,
            'createdAt': FieldValue.serverTimestamp(),
            'userId': _auth.currentUser?.uid ?? 'default_user',
          });
        }
      }
    }
  }
  
  Future<void> _deleteDosesForMedication(String medicationId) async {
    final query = await _dosesCollection
        .where('medId', isEqualTo: medicationId)
        .get();
    
    final batch = _firestore.batch();
    for (var doc in query.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
  
  bool _medAppliesOnDate(Medication med, DateTime date) {
    if (med.frequencyType == FrequencyType.daily) return true;
    
    if (med.frequencyType == FrequencyType.specificDays) {
      return med.specificDays.contains(date.weekday);
    }
    
    if (med.frequencyType == FrequencyType.everyXDays) {
      if (med.everyXDays == null) return true;

      return true;
    }
    return false;
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}