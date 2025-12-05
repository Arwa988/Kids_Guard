import 'package:flutter/material.dart';
import '../models/time_block.dart';

class AddTimeBlockDialog extends StatefulWidget {
  const AddTimeBlockDialog({Key? key}) : super(key: key);

  @override
  State<AddTimeBlockDialog> createState() => _AddTimeBlockDialogState();
}

class _AddTimeBlockDialogState extends State<AddTimeBlockDialog> {
  TimeOfDay? _start;
  TimeOfDay? _end;
  bool _recurring = true;

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) setState(() => _end = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add Time Block",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start time button
          TextButton(
            onPressed: _pickStart,
            child: Text(
              _start == null
                  ? "Select start time"
                  : "Start: ${_start!.hour.toString().padLeft(2, '0')}:${_start!.minute.toString().padLeft(2, '0')}",
            ),
          ),

          // End time button
          TextButton(
            onPressed: _pickEnd,
            child: Text(
              _end == null
                  ? "Select end time"
                  : "End: ${_end!.hour.toString().padLeft(2, '0')}:${_end!.minute.toString().padLeft(2, '0')}",
            ),
          ),

          const SizedBox(height: 10),

          // Recurring toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recurring"),
              Switch(
                value: _recurring,
                onChanged: (v) => setState(() => _recurring = v),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _start == null || _end == null
              ? null
              : () {
            Navigator.pop(
              context,
              TimeBlock(
                start: _start!,
                end: _end!,
                recurring: _recurring,
              ),
            );
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
