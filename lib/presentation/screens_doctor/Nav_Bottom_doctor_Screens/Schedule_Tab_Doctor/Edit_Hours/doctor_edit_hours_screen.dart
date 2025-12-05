import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Schedule_Tab_Doctor/Edit_Hours/widgets/day_row.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Schedule_Tab_Doctor/Edit_Hours/widgets/time_picker.dart';
import '../../../../../core/constants/App_Colors.dart';
import 'models/time_block.dart';


class DoctorEditHoursScreen extends StatefulWidget {
  const DoctorEditHoursScreen({Key? key}) : super(key: key);

  @override
  State<DoctorEditHoursScreen> createState() => _DoctorEditHoursScreenState();
}

class _DoctorEditHoursScreenState extends State<DoctorEditHoursScreen> {

  // Each day has its own list of time blocks
  final Map<String, List<TimeBlock>> schedule = {
    "Saturday": [],
    "Sunday": [],
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
  };

  // For adding a block
  void _addBlock(String dayName) async {
    final result = await showTimeRangePicker(context);
    if (result == null) return;

    setState(() {
      schedule[dayName]!.add(result);
    });
  }

  // For deleting a block
  void _deleteBlock(String dayName, int index) {
    setState(() {
      schedule[dayName]!.removeAt(index);
    });
  }

  // Toggle recurring/one-week
  void _toggleRecurring(String dayName, int index) {
    setState(() {
      final block = schedule[dayName]![index];
      block.recurring = !block.recurring;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kLightBlue,
        title: const Text(
          "Work Hour Management",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 20
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: schedule.keys.map((day) {
            return Column(
              children: [
                DayRow(
                  dayName: day,
                  blocks: schedule[day]!,
                  onAddBlock: () => _addBlock(day),
                  onDeleteBlock: (i) => _deleteBlock(day, i),
                  onToggleRecurring: (i) => _toggleRecurring(day, i),
                ),
                const SizedBox(height: 22),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
