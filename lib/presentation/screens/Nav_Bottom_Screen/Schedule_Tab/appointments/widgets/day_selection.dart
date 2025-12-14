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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final d = days[index];
          final selected = _isSameDate(d, selectedDate);
          final disabled = !_isInRange(d);
          final today = DateTime.now();
          final isToday = _isSameDate(d, today);

          return GestureDetector(
            onTap: disabled ? null : () => onSelectDate(d),
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                color: selected ? AppColors.lightBlue : 
                       isToday ? AppColors.lightBlue.withOpacity(0.1) : 
                       Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.lightBlue : 
                         isToday ? AppColors.lightBlue : 
                         Colors.grey.shade300,
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected ? [
                  BoxShadow(
                    color: AppColors.lightBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4)
                  )
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateHelpers.friendlyDayText(d).substring(0, 3),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : 
                             isToday ? AppColors.lightBlue : 
                             Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${d.day}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selected ? AppColors.lightBlue : 
                                 isToday ? AppColors.lightBlue : 
                                 Colors.black87,
                        ),
                      ),
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