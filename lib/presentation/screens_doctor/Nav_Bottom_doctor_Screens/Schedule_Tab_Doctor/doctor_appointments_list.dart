import 'package:flutter/material.dart';
import 'doctor_appointment_card.dart';

class DoctorAppointmentsList extends StatefulWidget {
  final DateTime selectedDate;

  const DoctorAppointmentsList({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<DoctorAppointmentsList> createState() => _DoctorAppointmentsListState();
}

class _DoctorAppointmentsListState extends State<DoctorAppointmentsList> {
  // Sample Data for demonstration
  List<Map<String, dynamic>> appointments = [
    {
      "date": DateTime(2025, 12, 12),
      "time": "09:00 AM",
      "child": "Ahmed Mohamed",
      "status": "pending",
    },
    {
      "date": DateTime(2025, 12, 5),
      "time": "10:30 AM",
      "child": "Sara Ibrahim",
      "status": "approved",
    },
    {
      "date": DateTime(2025, 12, 6),
      "time": "12:00 PM",
      "child": "Mostafa Fawzy",
      "status": "pending",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter by selected date
    List<Map<String, dynamic>> filtered = appointments.where((apt) {
      final d = apt["date"] as DateTime;
      return d.year == widget.selectedDate.year &&
          d.month == widget.selectedDate.month &&
          d.day == widget.selectedDate.day;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text("No appointments on this day"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final apt = filtered[index];

        return DoctorAppointmentCard(
          time: apt["time"],
          childName: apt["child"],
          status: apt["status"],
          onApprove: () {
            setState(() {
              apt["status"] = "approved";
            });
          },
          onReschedule: () {
            setState(() {
              appointments.remove(apt);
            });
          },
        );
      },
    );
  }
}
