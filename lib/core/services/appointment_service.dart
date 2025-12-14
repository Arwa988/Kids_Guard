import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _doctorBookingsPath(String doctorId) => 'appointments/$doctorId/bookings';
  String _guardianBookingsPath(String guardianId) => 'appointments/guardians_$guardianId/bookings';
  
  String get _currentUserId => _auth.currentUser!.uid;

  CollectionReference get _doctorBookingsCollection =>
      _firestore.collection(_doctorBookingsPath(_currentUserId));

  CollectionReference get _guardianBookingsCollection =>
      _firestore.collection(_guardianBookingsPath(_currentUserId));

  String _dayNumberToName(int dayNumber) {
    switch (dayNumber) {
      case 1: return "Monday";
      case 2: return "Tuesday";
      case 3: return "Wednesday";
      case 4: return "Thursday";
      case 5: return "Friday";
      case 6: return "Saturday";
      case 7: return "Sunday";
      default: return "Unknown";
    }
  }

  Future<String> createAppointment({
    required String doctorId,
    required String doctorName,
    required String date,
    required String time,
    required String childName,
  }) async {
    try {
      final appointmentId = _firestore.collection('appointments').doc().id;
      final currentUserId = _currentUserId;
      
      String finalDoctorId;
      if (doctorId.startsWith('doctors_doctors_')) {
        finalDoctorId = doctorId.substring(8);
      } else if (doctorId.startsWith('doctors_')) {
        finalDoctorId = doctorId;
      } else {
        finalDoctorId = 'doctors_$doctorId';
      }
      
      final appointmentData = {
        'id': appointmentId,
        'doctorId': finalDoctorId,
        'doctorName': doctorName,
        'date': date,
        'time': time,
        'childName': childName,
        'status': 'pending',
        'guardianId': currentUserId,
        'guardianName': _auth.currentUser!.displayName ?? 'Parent',
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      await _firestore
          .collection('appointments/$finalDoctorId/bookings')
          .doc(appointmentId)
          .set(appointmentData);
      
      await _firestore
          .collection('appointments/guardians_$currentUserId/bookings')
          .doc(appointmentId)
          .set({
        ...appointmentData,
        'doctorId': finalDoctorId,
      });
      
      return appointmentId;
      
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getDoctorAppointments() {
    return _doctorBookingsCollection
        .orderBy('date')
        .orderBy('time')
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

  Stream<List<Map<String, dynamic>>> getGuardianAppointments() {
    return _guardianBookingsCollection
        .orderBy('date')
        .orderBy('time')
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

  Stream<List<Map<String, dynamic>>> getDoctorAppointmentsByDate({
    required DateTime date, 
    required String doctorId
  }) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    return _firestore
        .collection('appointments')
        .doc(doctorId)
        .collection('bookings')
        .where('date', isEqualTo: dateStr)
        .orderBy('time')
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

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
    required String doctorId,
  }) async {
    try {
      String cleanDoctorId;
      if (doctorId.startsWith('doctors_doctors_')) {
        cleanDoctorId = doctorId.substring(8);
      } else if (doctorId.startsWith('doctors_')) {
        cleanDoctorId = doctorId;
      } else {
        cleanDoctorId = 'doctors_$doctorId';
      }
      
      final batch = _firestore.batch();
      
      final doctorPath = 'appointments/$cleanDoctorId/bookings';
      final doctorRef = _firestore.collection(doctorPath).doc(appointmentId);
      
      final doctorDoc = await doctorRef.get();
      if (!doctorDoc.exists) {
        throw Exception('Appointment not found');
      }
      
      batch.update(doctorRef, {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final guardianId = doctorDoc.data()?['guardianId'];
      
      if (guardianId != null && guardianId.isNotEmpty) {
        final guardianPath = 'appointments/guardians_$guardianId/bookings';
        final guardianRef = _firestore.collection(guardianPath).doc(appointmentId);
        
        final guardianDoc = await guardianRef.get();
        if (guardianDoc.exists) {
          batch.update(guardianRef, {
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      
      await batch.commit();
      
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rescheduleAppointment({
    required String appointmentId,
    required String newDate,
    required String newTime,
    required String doctorId,
  }) async {
    try {
      String cleanDoctorId;
      if (doctorId.startsWith('doctors_doctors_')) {
        cleanDoctorId = doctorId.substring(8);
      } else if (doctorId.startsWith('doctors_')) {
        cleanDoctorId = doctorId;
      } else {
        cleanDoctorId = 'doctors_$doctorId';
      }
      
      final batch = _firestore.batch();

      final doctorRef = _firestore
          .collection('appointments/$cleanDoctorId/bookings')
          .doc(appointmentId);
      
      batch.update(doctorRef, {
        'date': newDate,
        'time': newTime,
        'status': 'rescheduled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final appointmentDoc = await doctorRef.get();
      final guardianId = appointmentDoc.data()?['guardianId'];
      
      if (guardianId != null) {
        final guardianRef = _firestore
            .collection('appointments/guardians_$guardianId/bookings')
            .doc(appointmentId);
        
        batch.update(guardianRef, {
          'date': newDate,
          'time': newTime,
          'status': 'rescheduled',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getAvailableSlotsForDay({
    required String doctorId,
    required String date,
    required int dayOfWeek,
  }) async {
    try {
      String cleanDoctorId;
      if (doctorId.startsWith('doctors_')) {
        cleanDoctorId = doctorId;
      } else {
        cleanDoctorId = 'doctors_$doctorId';
      }
      
      final availabilitySnapshot = await _firestore
          .collection('appointments')
          .doc(cleanDoctorId)
          .collection('availability')
          .where('dayOfWeek', isEqualTo: dayOfWeek)
          .where('isRecurring', isEqualTo: true)
          .get();

      if (availabilitySnapshot.docs.isEmpty) {
        return [];
      }

      final bookingsSnapshot = await _firestore
          .collection('appointments/$cleanDoctorId/bookings')
          .where('date', isEqualTo: date)
          .where('status', whereIn: ['pending', 'approved'])
          .get();

      final bookedTimes = bookingsSnapshot.docs
          .map((doc) => doc.data()['time'] as String)
          .toList();

      final availableSlots = <String>[];

      for (var doc in availabilitySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final startTime = data['startTime'] as String;
        final endTime = data['endTime'] as String;

        final startParts = startTime.split(':');
        final endParts = endTime.split(':');
        
        final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
        final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

        for (int minutes = startMinutes; minutes < endMinutes; minutes += 30) {
          final hour = (minutes ~/ 60).toString().padLeft(2, '0');
          final minute = (minutes % 60).toString().padLeft(2, '0');
          final timeSlot = '$hour:$minute';

          if (!bookedTimes.contains(timeSlot)) {
            availableSlots.add(timeSlot);
          }
        }
      }
      
      return availableSlots;
      
    } catch (e) {
      final fallback = [
        "09:00", "09:30", "10:00", "10:30",
        "11:00", "11:30", "14:00", "14:30",
      ];
      return fallback;
    }
  }

  Stream<List<Map<String, dynamic>>> getDoctorAppointmentsByDateForDoctor({
    required DateTime date,
    required String doctorId,
  }) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    String cleanDoctorId;
    if (doctorId.startsWith('doctors_doctors_')) {
      cleanDoctorId = doctorId.substring(8);
    } else if (doctorId.startsWith('doctors_')) {
      cleanDoctorId = doctorId;
    } else {
      cleanDoctorId = 'doctors_$doctorId';
    }
    
    final path = 'appointments/$cleanDoctorId/bookings';
    
    return _firestore
        .collection(path)
        .where('date', isEqualTo: dateStr)
        .orderBy('time')
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

  Stream<List<Map<String, dynamic>>> getDoctorAppointmentsByDateForGuardian({
    required DateTime date,
    required String doctorId,
  }) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    String cleanDoctorId;
    if (doctorId.startsWith('doctors_doctors_')) {
      cleanDoctorId = doctorId.substring(8);
    } else if (doctorId.startsWith('doctors_')) {
      cleanDoctorId = doctorId;
    } else {
      cleanDoctorId = 'doctors_$doctorId';
    }
    
    final path = 'appointments/$cleanDoctorId/bookings';
    
    return _firestore
        .collection(path)
        .where('date', isEqualTo: dateStr)
        .orderBy('time')
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
}