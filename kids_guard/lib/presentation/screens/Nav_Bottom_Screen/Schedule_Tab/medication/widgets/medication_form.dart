import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'medication_model.dart';
import 'package:uuid/uuid.dart';

class MedicationForm extends StatefulWidget {
  final Medication? edit;
  final void Function(Medication) onSave;
  const MedicationForm({Key? key, this.edit, required this.onSave}) : super(key: key);

  @override
  State<MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  FrequencyType _freq = FrequencyType.daily;
  List<int> _specificDays = [];
  int _everyX = 2;
  List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];

  @override
  void initState() {
    super.initState();
    if (widget.edit != null) {
      final e = widget.edit!;
      _nameCtrl.text = e.name;
      _dosageCtrl.text = e.dosage;
      _freq = e.frequencyType;
      _specificDays = List.from(e.specificDays);
      _everyX = e.everyXDays ?? 2;
      _times = List.from(e.times);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(context: context, initialTime: _times[index]);
    if (picked != null) setState(() => _times[index] = picked);
  }

  void _addTime() {
    setState(() => _times.add(const TimeOfDay(hour: 20, minute: 0)));
  }

  void _removeTime(int idx) {
    setState(() => _times.removeAt(idx));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                widget.edit == null ? 'Add Medication' : 'Edit Medication',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 12),
            TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Medicine name'
                )
            ),
            const SizedBox(height: 12),
            TextField(
                controller: _dosageCtrl,
                decoration: const InputDecoration(
                    labelText: 'Dosage (e.g. 10mg)'
                )
            ),
            const SizedBox(height: 12),

            // Frequency selector
            Align(
                alignment: Alignment.centerLeft,
                child: const Text('Frequency',
                    style: TextStyle(fontWeight: FontWeight.w600)
                )
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<FrequencyType>(
              value: _freq,
              items: FrequencyType.values.map((f) => DropdownMenuItem(
                  value: f,
                  child: Text(f.toString().split('.').last)
              )
              ).toList(),
              onChanged: (v) => setState(() => _freq = v!),
              dropdownColor: Colors.white,
            ),

            const SizedBox(height: 12),
            if (_freq == FrequencyType.specificDays) ...[
              Wrap(
                spacing: 8,
                children: List.generate(7, (i) {
                  final weekday = i + 1; // Mon=1
                  final label = DateFormat.E().format(DateTime(2020,1,5 + i));
                  final selected = _specificDays.contains(weekday);
                  return FilterChip(
                    selected: selected,
                    label: Text(label),
                    onSelected: (s) => setState(() {
                      if (s) _specificDays.add(weekday); else _specificDays.remove(weekday);
                    }),
                  );
                }),
              ),
            ],

            if (_freq == FrequencyType.everyXDays) ...[
              const SizedBox(height: 8),
              Row(children: [
                const Text('Every'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: _everyX.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _everyX = int.tryParse(v) ?? 2,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('days'),
              ]),
            ],

            const SizedBox(height: 12),
            Align(
                alignment: Alignment.centerLeft,
                child: const Text('Times',
                    style: TextStyle(fontWeight: FontWeight.w600)
                )
            ),
            const SizedBox(height: 8),
            Column(
              children: List.generate(_times.length, (i) {
                return Row(
                  children: [
                    Expanded(child: Text(_times[i].format(context))),
                    IconButton(
                        onPressed: () => _pickTime(i),
                        icon: const Icon(Icons.access_time)),
                    IconButton(
                        onPressed: () => _removeTime(i),
                        icon: const Icon(Icons.delete, color: AppColors.errorRed),
                    ),
                  ],
                );
              }),
            ),
            TextButton.icon(
                onPressed: _addTime,
                icon: const Icon(Icons.add),
                label: const Text('Add time')
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.lightBlue),
                onPressed: () {
                  if (_nameCtrl.text.trim().isEmpty) return;
                  final id = widget.edit?.id ?? const Uuid().v4();
                  final med = Medication(
                    id: id,
                    name: _nameCtrl.text.trim(),
                    dosage: _dosageCtrl.text.trim(),
                    frequencyType: _freq,
                    specificDays: _specificDays,
                    everyXDays: _everyX,
                    times: _times,
                  );
                  widget.onSave(med);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
