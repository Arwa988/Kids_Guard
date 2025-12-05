import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/core/utils/date_helpers.dart';

class DaySelection extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime maxDate;
  final Function(DateTime) onSelectDate;

  const DaySelection({
    super.key,
    required this.selectedDate,
    required this.startDate,
    required this.maxDate,
    required this.onSelectDate,
  });

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime d) =>
      !d.isBefore(startDate) && !d.isAfter(maxDate);

  List<DateTime> _generate7Days() {
    return List.generate(7, (i) => startDate.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final days = _generate7Days();

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final d = days[index];
          final selected = _isSameDate(d, selectedDate);
          final disabled = !_isInRange(d);

          return GestureDetector(
            onTap: disabled ? null : () => onSelectDate(d),
            child: Container(
              width: 72,
              decoration: BoxDecoration(
                color: selected ? AppColors.lightBlue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                    selected ? Colors.transparent : Colors.grey.shade300),
                boxShadow: selected
                    ? [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateHelpers.friendlyDayText(d),
                    style: TextStyle(
                      fontSize: 13, // optional
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${d.day}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
