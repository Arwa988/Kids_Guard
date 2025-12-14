import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/core/services/appointment_service.dart';
import 'package:kids_guard/core/services/availability_service.dart';
import 'widgets/day_selection.dart';
import 'widgets/month_calendar.dart';
import 'widgets/time_selection.dart';

class DocAppointment extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const DocAppointment({
    Key? key,
    required this.doctorId,
    required this.doctorName,
  }) : super(key: key);

  @override
  State<DocAppointment> createState() => _DocAppointmentState();
}

class _DocAppointmentState extends State<DocAppointment> {
  late AppointmentService _appointmentService;
  late AvailabilityService _availabilityService;

  final DateTime today = DateTime.now();
  late final DateTime startDate;
  late final DateTime maxDate;
  DateTime selectedDate = DateTime.now();
  late DateTime showingMonth;

  List<String> availableTimes = [];
  final List<String> bookedSlots = [];
  String? selectedTime;

  bool showFullCalendar = false;
  bool _isLoading = true;
  String _childName = '';

  @override
  void initState() {
    super.initState();
    _appointmentService = AppointmentService();
    _availabilityService = AvailabilityService();

    startDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1));
    maxDate = startDate.add(const Duration(days: 90));
    selectedDate = startDate;
    showingMonth = DateTime(startDate.year, startDate.month);

    _loadAvailableTimes();
    _loadBookedSlots();
  }

  String _dateKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  int _getDayOfWeek(DateTime d) {
    return d.weekday;
  }

  Future<void> _loadBookedSlots() async {
    try {
      final appointments = await _appointmentService
          .getDoctorAppointmentsByDateForGuardian(
            date: selectedDate,
            doctorId: widget.doctorId,
          )
          .first;
      
      if (mounted) {
        setState(() {
          bookedSlots.clear();
          for (var apt in appointments) {
            if (apt["status"] == "pending" || apt["status"] == "approved") {
              bookedSlots.add('${apt["date"]}|${apt["time"]}');
            }
          }
        });
      }
    } catch (e) {
      //   print  
    }
  }

  Future<void> _loadAvailableTimes() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    final dayOfWeek = _getDayOfWeek(selectedDate);
    final dateStr = _dateKey(selectedDate);

    try {
      final slots = await _appointmentService.getAvailableSlotsForDay(
        doctorId: widget.doctorId,
        date: dateStr,
        dayOfWeek: dayOfWeek,
      );

      if (mounted) {
        setState(() {
          availableTimes = slots;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          availableTimes = _getFallbackTimes();
          _isLoading = false;
        });
      }
    }
  }

  List<String> _getFallbackTimes() {
    return [
      "09:00", "09:30", "10:00", "10:30",
      "11:00", "11:30", "14:00", "14:30",
      "15:00", "15:30", "16:00", "16:30",
    ];
  }

  bool _isInRange(DateTime d) => !d.isBefore(startDate) && !d.isAfter(maxDate);

  void _selectDate(DateTime date) {
    if (!_isInRange(date)) return;
    setState(() {
      selectedDate = date;
      showingMonth = DateTime(date.year, date.month);
      selectedTime = null;
      _childName = '';
      _loadAvailableTimes();
      _loadBookedSlots();
    });
  }

  void _changeMonth(DateTime newMonth) {
    setState(() => showingMonth = newMonth);
  }

  void _onTapTime(String time) {
    setState(() => selectedTime = time);
  }

  Future<void> _onConfirmBooking() async {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    String tempChildName = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doctor: ${widget.doctorName}'),
              const SizedBox(height: 8),
              Text('Date: ${DateFormat.yMMMd().format(selectedDate)}'),
              const SizedBox(height: 8),
              Text('Time: $selectedTime'),
              const SizedBox(height: 16),
              const Text('Child Name:'),
              SizedBox(
                height: 40,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter child name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    tempChildName = value;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (tempChildName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter child name'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                _childName = tempChildName;
                Navigator.pop(context);
                _processBooking();
              },
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processBooking() async {
    try {
      await _appointmentService.createAppointment(
        doctorId: widget.doctorId,
        doctorName: widget.doctorName,
        date: _dateKey(selectedDate),
        time: selectedTime!,
        childName: _childName,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Booking Confirmed!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Your appointment with ${widget.doctorName} is pending approval.',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
          padding: const EdgeInsets.all(16),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      if (mounted) {
        setState(() {
          bookedSlots.add(
            '${_dateKey(selectedDate)}|$selectedTime',
          );
          availableTimes.remove(selectedTime);
          selectedTime = null;
          _childName = '';
        });
      }

      _loadAvailableTimes();
      _loadBookedSlots();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Appointment with ${widget.doctorName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
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
                            onTap: () => setState(
                              () => showFullCalendar = !showFullCalendar,
                            ),
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
                      const Text(
                        "Available Time Slots",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (availableTimes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "No available times for this date. Please select another day.",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        Column(
                          children: [
                            TimeSelection(
                              times: availableTimes,
                              selectedTime: selectedTime,
                              selectedDate: selectedDate,
                              bookedSlots: bookedSlots,
                              onTapTime: _onTapTime,
                            ),

                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.blue[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Times are based on doctor\'s availability',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onConfirmBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Book Appointment",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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