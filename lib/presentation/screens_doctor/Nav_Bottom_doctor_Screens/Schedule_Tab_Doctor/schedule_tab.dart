import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/core/services/appointment_service.dart';
import 'Edit_Hours/doctor_edit_hours_screen.dart';
import 'doctor_appointments_list.dart';
import '../../../screens/Nav_Bottom_Screen/Schedule_Tab/appointments/widgets/month_calendar.dart';
import '../../../screens/Nav_Bottom_Screen/Schedule_Tab/appointments/widgets/day_selection.dart';

class ScheduleTabDoctor extends StatefulWidget {
  const ScheduleTabDoctor({Key? key}) : super(key: key);

  @override
  State<ScheduleTabDoctor> createState() => _ScheduleTabDoctorState();
}

class _ScheduleTabDoctorState extends State<ScheduleTabDoctor> {
  DateTime selectedDate = DateTime.now();
  DateTime showingMonth = DateTime.now();
  bool showFullCalendar = false;

  late AppointmentService _appointmentService;
  late String _doctorId;

  final DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  final DateTime maxDate = DateTime.now().add(const Duration(days: 90));

  @override
  void initState() {
    super.initState();
    _appointmentService = AppointmentService();

    _doctorId = 'doctors_HEEH0twV0rWVvVdhLcUkyc8cszH2';
    print('👨‍⚕️ DOCTOR ID set to: $_doctorId');
  }

  void _selectDate(DateTime d) {
    setState(() {
      selectedDate = d;
      showingMonth = DateTime(d.year, d.month);
      showFullCalendar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kLightBlue,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Schedule",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _appointmentService.getDoctorAppointments(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('❌ Stream Error: ${snapshot.error}');
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_calendar_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DoctorEditHoursScreen(),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (!snapshot.hasData) {
                return IconButton(
                  icon: const Icon(
                    Icons.edit_calendar_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorEditHoursScreen(),
                      ),
                    );
                  },
                );
              }

              final pendingCount = snapshot.data!
                  .where((apt) => apt["status"] == "pending")
                  .length;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_calendar_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorEditHoursScreen(),
                        ),
                      );
                    },
                  ),
                  if (pendingCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          pendingCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 30),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // WEEK SELECTOR + DROPDOWN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: DaySelection(
                    selectedDate: selectedDate,
                    startDate: selectedDate,
                    maxDate: maxDate,
                    onSelectDate: _selectDate,
                  ),
                ),

                const SizedBox(width: 8),

                InkWell(
                  onTap: () => setState(() {
                    showFullCalendar = !showFullCalendar;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      showFullCalendar
                          ? Icons.calendar_month_outlined
                          : Icons.expand_more,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // MONTH CALENDAR
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: showFullCalendar
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: MonthCalendar(
                      showingMonth: showingMonth,
                      selectedDate: selectedDate,
                      startDate: startDate,
                      maxDate: maxDate,
                      onSelectDate: _selectDate,
                      onChangeMonth: (m) => setState(() => showingMonth = m),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // APPOINTMENTS LIST (DATE-DRIVEN)
          Expanded(
            child: DoctorAppointmentsList(
              selectedDate: selectedDate,
              doctorId: _doctorId,
            ),
          ),
        ],
      ),
    );
  }
}
