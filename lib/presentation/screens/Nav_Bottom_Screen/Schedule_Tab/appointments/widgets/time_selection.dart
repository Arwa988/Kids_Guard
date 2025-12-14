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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isBooked 
                  ? Colors.grey[100] 
                  : (isSelected ? AppColors.lightBlue : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isBooked 
                    ? Colors.grey[300]!
                    : (isSelected ? Colors.transparent : Colors.grey.shade300),
              ),
              boxShadow: isSelected && !isBooked
                  ? [
                      BoxShadow(
                        color: AppColors.lightBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isBooked ? Colors.grey : Colors.black87),
                    decoration: isBooked ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                if (isBooked) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.lock_clock,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}