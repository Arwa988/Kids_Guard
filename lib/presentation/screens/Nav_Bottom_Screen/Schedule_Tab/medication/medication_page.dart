import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import '../medication/widgets/medication_controller.dart';
import '../medication/widgets/medication_form.dart';
import '../medication/widgets/medication_card.dart';
import '../medication/widgets/medication_model.dart';
import 'package:uuid/uuid.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({Key? key}) : super(key: key);

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {

  final MedicationController _controller = MedicationController();
  String _filter = 'today'; // default

  @override
  void initState() {
    super.initState();
    // create sample data for demo
    final m1 = Medication(
        id: const Uuid().v4(),
        name: 'Paracetamol',
        dosage: '500 mg', frequencyType: FrequencyType.daily,
        times: [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 20, minute: 0)]
    );
    final m2 = Medication(
        id: const Uuid().v4(),
        name: 'Vitamin D',
        dosage: '1 tablet',
        frequencyType: FrequencyType.specificDays,
        specificDays: [DateTime.now().weekday],
        times: [const TimeOfDay(hour: 9, minute: 0)]
    );
    _controller.addMedication(m1);
    _controller.addMedication(m2);
    _controller.generateTodaysDoses();
    _controller.addListener(() => setState(() {}));
  }

  void _openForm({Medication? edit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return MedicationForm(
          edit: edit,
          onSave: (med) {
            if (edit == null) {
              _controller.addMedication(med);
            } else {
              _controller.editMedication(edit.id, med);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayList = _controller.todayDoses;
    final allList = _controller.allMeds;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _filter,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black54,     // visible arrow
              iconDisabledColor: Colors.grey,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'today',
                  child: Text('Today', style: TextStyle(color: Colors.black87)),
                ),
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All', style: TextStyle(color: Colors.black87)),
                ),
              ],
              onChanged: (v) => setState(() => _filter = v!),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightBlue,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _filter == 'today' ? _buildTodayView(todayList) : _buildAllView(allList),
      ),
    );
  }

  Widget _buildTodayView(List<MedicationDose> doses) {
    if (doses.isEmpty) return const Center(child: Text('No medications for today', style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      itemCount: doses.length,
      itemBuilder: (context, idx) {
        final dose = doses[idx];
        return MedicationCard(
          dose: dose,
          onTapCheck: () async {
            // compute on time vs late
            final onTime = _controller.markTakenWithCheck(dose.id);
            // show supportive message instead of confirmation
            if (onTime) {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                    title: const Text('Nice!'),
                    content: const Text('Great job — you took it on time.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK')
                      )
                    ]
                )
              );
            } else {
              await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      title: const Text("Heads up"),
                      content: const Text("It's important to take medicine on time."),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK')
                        )
                      ]
                  )
              );
            }
          },
          onEdit: () {
            // do nothing for today doses - editing should happen in All view
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit from All tab')));
          },
          onDelete: () {},
        );
      },
    );
  }

  Widget _buildAllView(List<Medication> meds) {
    if (meds.isEmpty) return const Center(child: Text('No medications', style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      itemCount: meds.length,
      itemBuilder: (context, idx) {
        final med = meds[idx];
        return ListTile(
          title: Text(med.name),
          subtitle: Text('${med.dosage} • ${med.times.map((t) => t.format(context)).join(', ')}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(edit: med)),
            IconButton(icon: const Icon(Icons.delete, color: AppColors.errorRed), onPressed: () => _confirmDelete(med.id)),
          ]),
        );
      },
    );
  }

  void _confirmDelete(String id) async {
    final res = await showDialog<bool>(
      context: context, builder: (_) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this medication?'),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')
        ),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: AppColors.errorRed))
          )
        ]
      )
    );
    if (res == true) {
      _controller.deleteMedication(id);
    }
  }
}
