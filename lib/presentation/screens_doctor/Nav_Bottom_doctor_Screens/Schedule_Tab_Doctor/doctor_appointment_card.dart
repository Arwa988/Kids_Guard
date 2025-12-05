import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

class DoctorAppointmentCard extends StatelessWidget {
  final String time;
  final String childName;
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onReschedule;

  const DoctorAppointmentCard({
    Key? key,
    required this.time,
    required this.childName,
    required this.status,
    required this.onApprove,
    required this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isApproved = status == "approved";

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => onReschedule(),

      background: Container(
        decoration: BoxDecoration(
          color: Colors.orange.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Reschedule',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isApproved ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.08),
            )
          ],
        ),

        child: Row(
          children: [
            // Left colored strip
            Container(
              width: 5,
              height: 75,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kTextColor,
                        decoration: isApproved
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isApproved
                          ? "$childName is approved"
                          : "Approve $childName?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        decoration: isApproved
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right-side icon
            if (isApproved)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: onApprove,
                  child: const Icon(
                    Icons.circle_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
