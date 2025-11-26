import 'package:flutter/material.dart';
import '../../../../../../core/constants/App_Colors.dart';
import 'medication_model.dart';
import 'package:intl/intl.dart';

class MedicationCard extends StatelessWidget {
  final MedicationDose dose;
  final bool showMedicName;
  final VoidCallback onTapCheck;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicationCard({Key? key, required this.dose, this.showMedicName = true, required this.onTapCheck, required this.onEdit, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduled = TimeOfDay(
        hour: dose.time.hour,
        minute: dose.time.minute).format(context);
    final taken = dose.taken;
    return Dismissible(
      key: ValueKey(dose.id),
      background: Container(
        color: Colors.blueAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: AppColors.errorRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          onEdit();
          return false; // keep item
        } else {
          final res = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
            title: const Text('Delete medication'),
            content: const Text('Are you sure you want to delete this medication?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete',
                      style: TextStyle(color: AppColors.errorRed)
                  )
              )
            ],
          ));
          if (res == true) onDelete();
          return res ?? false;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: taken ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0,3)
            )
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onTapCheck,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: taken ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child:
                Center(
                    child: taken ? const Icon(Icons.check, color: Colors.white) : const Icon(Icons.circle_outlined, color: Colors.grey)
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      dose.medName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: taken ? Colors.black45 : Colors.black87
                      )
                  ),
                  const SizedBox(height: 4),
                  Text(
                      '${dose.dosage} • $scheduled',
                      style: TextStyle(
                          color: taken ? Colors.black38 : Colors.black54
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (dose.taken && dose.takenAt != null) Text(
                DateFormat.Hm().format(dose.takenAt!),
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45
                )
            ),
          ],
        ),
      ),
    );
  }
}
