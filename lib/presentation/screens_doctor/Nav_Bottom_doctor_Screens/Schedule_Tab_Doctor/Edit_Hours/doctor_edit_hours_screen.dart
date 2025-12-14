import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Schedule_Tab_Doctor/Edit_Hours/widgets/day_row.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Schedule_Tab_Doctor/Edit_Hours/widgets/time_picker.dart';
import '../../../../../core/constants/App_Colors.dart';
import 'models/time_block.dart';
import 'package:kids_guard/core/services/availability_service.dart'; 

class DoctorEditHoursScreen extends StatefulWidget {
  const DoctorEditHoursScreen({Key? key}) : super(key: key);

  @override
  State<DoctorEditHoursScreen> createState() => _DoctorEditHoursScreenState();
}

class _DoctorEditHoursScreenState extends State<DoctorEditHoursScreen> {
  final AvailabilityService _availabilityService = AvailabilityService();
  
  final Map<String, int> _dayToNumber = {
    "Monday": 1,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
    "Saturday": 6,
    "Sunday": 7,
  };

  final Map<int, String> _numberToDay = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };


  final Map<String, List<TimeBlock>> _localSchedule = {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  };


  final Map<String, List<String>> _availabilityIds = {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailabilityFromFirebase();
  }


  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }


  TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }


  Future<void> _loadAvailabilityFromFirebase() async {
    try {

      _localSchedule.forEach((key, value) => value.clear());
      _availabilityIds.forEach((key, value) => value.clear());

 
      _availabilityService.getDoctorAvailability().listen((List<Map<String, dynamic>> availabilityList) {
        if (mounted) {
          setState(() {

            _localSchedule.forEach((key, value) => value.clear());
            _availabilityIds.forEach((key, value) => value.clear());
            

            for (var avail in availabilityList) {
              final dayNumber = avail['dayOfWeek'] as int;
              final dayName = _numberToDay[dayNumber];
              
              if (dayName != null && _localSchedule.containsKey(dayName)) {
                _localSchedule[dayName]!.add(TimeBlock(
                  start: _stringToTimeOfDay(avail['startTime']),
                  end: _stringToTimeOfDay(avail['endTime']),
                  recurring: avail['isRecurring'] ?? true,
                ));
                
                _availabilityIds[dayName]!.add(avail['id']);
              }
            }
            
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('❌ Error loading availability: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  Future<void> _addBlock(String dayName) async {
    final result = await showTimeRangePicker(context);
    if (result == null) return;

    try {
      await _availabilityService.addAvailability(
        dayOfWeek: _dayToNumber[dayName]!,
        startTime: _timeOfDayToString(result.start),
        endTime: _timeOfDayToString(result.end),
        isRecurring: result.recurring,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added time block for $dayName'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error adding availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _deleteBlock(String dayName, int index) async {
    try {
      final availabilityId = _availabilityIds[dayName]![index];
      await _availabilityService.deleteAvailability(availabilityId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted time block'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error deleting availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _toggleRecurring(String dayName, int index) async {
    try {
      final availabilityId = _availabilityIds[dayName]![index];
      final currentBlock = _localSchedule[dayName]![index];
      final newRecurring = !currentBlock.recurring;
      
      await _availabilityService.toggleRecurring(availabilityId, newRecurring);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated recurring status'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('❌ Error toggling recurring: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kLightBlue,
          title: const Text(
            "Work Hour Management",
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kLightBlue,
        title: const Text(
          "Work Hour Management",
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _localSchedule.keys.map((day) {
            return Column(
              children: [
                DayRow(
                  dayName: day,
                  blocks: _localSchedule[day]!,
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