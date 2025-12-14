// File: lib/core/services/availability_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  CollectionReference get _doctorAvailabilityCollection {
    final doctorId = _auth.currentUser!.uid;
    return _firestore
        .collection('appointments')
        .doc('doctors_$doctorId')  
        .collection('availability');
  }

  // 1. add available time
  Future<void> addAvailability({
    required int dayOfWeek, 
    required String startTime, 
    required String endTime, 
    required bool isRecurring,
  }) async {
    await _doctorAvailabilityCollection.add({
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isRecurring': isRecurring,
      'doctorId': _auth.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 2. all times doc are free
  Stream<List<Map<String, dynamic>>> getDoctorAvailability() {
    return _doctorAvailabilityCollection
        .orderBy('dayOfWeek')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    });
  }

  // 3. حذف وقت فاضي
  Future<void> deleteAvailability(String availabilityId) async {
    await _doctorAvailabilityCollection.doc(availabilityId).delete();
  }

  Future<void> toggleRecurring(String availabilityId, bool isRecurring) async {
    await _doctorAvailabilityCollection.doc(availabilityId).update({
      'isRecurring': isRecurring,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getDoctorAvailabilityForGuardian(
      String doctorId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .doc('doctors_$doctorId') 
        .collection('availability')
        .where('isRecurring', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }
}