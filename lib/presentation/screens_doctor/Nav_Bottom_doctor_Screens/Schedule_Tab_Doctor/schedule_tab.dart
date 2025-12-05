import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'Edit_Hours/doctor_edit_hours_screen.dart';
import 'doctor_appointments_list.dart';

// Reused
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

  final DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  final DateTime maxDate = DateTime.now().add(const Duration(days: 90));

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
        backgroundColor: AppColors.kLightBlue,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Schedule",
            style: TextStyle(
              color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoctorEditHoursScreen()),
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
                onChangeMonth: (m) =>
                    setState(() => showingMonth = m),
              ),
            )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // APPOINTMENTS LIST (DATE-DRIVEN)
          Expanded(
            child: DoctorAppointmentsList(selectedDate: selectedDate),
          ),
        ],
      ),
    );
  }
}
