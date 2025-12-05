import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/core/utils/date_helpers.dart';

class MonthCalendar extends StatelessWidget {
  final DateTime showingMonth;
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime maxDate;
  final Function(DateTime) onSelectDate;
  final Function(DateTime) onChangeMonth;

  const MonthCalendar({
    super.key,
    required this.showingMonth,
    required this.selectedDate,
    required this.startDate,
    required this.maxDate,
    required this.onSelectDate,
    required this.onChangeMonth,
  });

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime d) =>
      !d.isBefore(startDate) && !d.isAfter(maxDate);

  List<DateTime> _monthGridDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);

    int leading = (first.weekday) % 7;
    List<DateTime> days = [];

    for (int i = 0; i < leading; i++) {
      days.add(first.subtract(Duration(days: leading - i)));
    }

    for (int d = 1; d <= last.day; d++) {
      days.add(DateTime(month.year, month.month, d));
    }

    while (days.length % 7 != 0) {
      days.add(last.add(Duration(days: days.length % 7)));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _monthGridDays(showingMonth);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => onChangeMonth(
                DateTime(showingMonth.year, showingMonth.month - 1),
              ),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(DateHelpers.friendlyDayText(selectedDate)),
                    Text(DateFormat.yMMMM().format(showingMonth)),
                  ],
                )
              ),
            ),
            IconButton(
              onPressed: () => onChangeMonth(
                DateTime(showingMonth.year, showingMonth.month + 1),
              ),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),

        const SizedBox(height: 8),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final d = days[index];
            final inMonth = d.month == showingMonth.month;
            final selected = _isSameDate(d, selectedDate);
            final disabled = !_isInRange(d);

            return GestureDetector(
              onTap:
              disabled || !inMonth ? null : () => onSelectDate(d),
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.lightBlue
                      : (inMonth ? Colors.white : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    "${d.day}",
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : (inMonth ? Colors.black : Colors.black26),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
