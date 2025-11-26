import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

import '../appointments/widgets/doctor_header.dart';
import '../appointments/widgets/day_selection.dart';
import '../appointments/widgets/month_calendar.dart';
import '../appointments/widgets/time_selection.dart';

class DocAppointment extends StatefulWidget {
  const DocAppointment({Key? key}) : super(key: key);

  @override
  State<DocAppointment> createState() => _DocAppointmentState();
}

class _DocAppointmentState extends State<DocAppointment>
    with TickerProviderStateMixin {
  // Dates & limits
  final DateTime today = DateTime.now();
  late final DateTime startDate;
  late final DateTime maxDate;
  DateTime selectedDate = DateTime.now();
  late DateTime showingMonth;

  // Time slots
  final Map<String, List<String>> AvailableTimes = {};
  final List<String> bookedSlots = [];
  String? selectedTime;

  // UI
  bool showFullCalendar = false;

  @override
  void initState() {
    super.initState();
    startDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1));
    maxDate = startDate.add(const Duration(days: 90));
    selectedDate = startDate;
    showingMonth = DateTime(startDate.year, startDate.month);

    // mock times
    DateTime d = startDate;
    while (!d.isAfter(maxDate)) {
      AvailableTimes[_dateKey(d)] = [
        "09:00 AM",
        "09:30 AM",
        "10:00 AM",
        "10:30 AM",
        "11:00 AM",
        "01:00 PM",
        "02:30 PM",
      ];
      d = d.add(const Duration(days: 1));
    }
  }

  String _dateKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  bool _isInRange(DateTime d) =>
      !d.isBefore(startDate) && !d.isAfter(maxDate);

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // actions
  void _selectDate(DateTime date) {
    if (!_isInRange(date)) return;
    setState(() {
      selectedDate = date;
      showingMonth = DateTime(date.year, date.month);
      selectedTime = null;
    });
  }

  void _changeMonth(DateTime newMonth) {
    setState(() => showingMonth = newMonth);
  }

  void _onTapTime(String time) {
    setState(() => selectedTime = time);
  }

  void _onConfirmBooking() {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time first')),
      );
      return;
    }

    final key = _dateKey(selectedDate);
    final bookedKey = '$key|$selectedTime';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Appointment'),
          content: Text(
              'Book appointment on ${DateFormat.yMMMd().format(selectedDate)} at $selectedTime?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                setState(() {
                  bookedSlots.add(bookedKey);
                  AvailableTimes[key]?.remove(selectedTime);
                  selectedTime = null;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment booked')));
              },
              child: Text('Book',
                  style: TextStyle(color: AppColors.textPrimary)),
            ),
          ],
        );
      },
    );
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    final times = AvailableTimes[_dateKey(selectedDate)] ?? [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            const DoctorHeader(),

            // APPOINTMENT CARD
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 36),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, 8))
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text("Appointment",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: DaySelection(
                              selectedDate: selectedDate,
                              startDate: startDate,
                              maxDate: maxDate,
                              onSelectDate: _selectDate,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => setState(() =>
                            showFullCalendar = !showFullCalendar),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[100],
                              ),
                              child: Icon(
                                showFullCalendar
                                    ? Icons.calendar_month_outlined
                                    : Icons.expand_more_rounded,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: showFullCalendar
                            ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: MonthCalendar(
                            showingMonth: showingMonth,
                            startDate: startDate,
                            maxDate: maxDate,
                            selectedDate: selectedDate,
                            onSelectDate: _selectDate,
                            onChangeMonth: _changeMonth,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 20),
                      const Text("Available Time",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 20),

                      TimeSelection(
                        times: times,
                        selectedTime: selectedTime,
                        selectedDate: selectedDate,
                        bookedSlots: bookedSlots,
                        onTapTime: _onTapTime,
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onConfirmBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimaryColor,
                            padding:
                            const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
