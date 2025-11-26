import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

class TimeSelection extends StatelessWidget {
  final List<String> times;
  final String? selectedTime;
  final DateTime selectedDate;
  final List<String> bookedSlots;
  final Function(String) onTapTime;

  const TimeSelection({
    super.key,
    required this.times,
    required this.selectedTime,
    required this.selectedDate,
    required this.bookedSlots,
    required this.onTapTime,
  });

  String _dateKey(DateTime d) =>
      DateFormat('yyyy-MM-dd').format(d);

  @override
  Widget build(BuildContext context) {
    if (times.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text("No available times for this date.",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: times.map((t) {
        final bookedKey = "${_dateKey(selectedDate)}|$t";
        final isBooked = bookedSlots.contains(bookedKey);
        final isSelected = selectedTime == t;

        return GestureDetector(
          onTap: isBooked ? null : () => onTapTime(t),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.lightBlue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                    color: Colors.orange.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 6))
              ]
                  : null,
            ),
            child: Text(
              t,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isBooked ? Colors.grey : Colors.black87),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
