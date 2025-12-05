import 'package:flutter/material.dart';
import '../models/time_block.dart';

class TimeBlockCard extends StatelessWidget {
  final TimeBlock block;
  final VoidCallback onDelete;
  final VoidCallback onToggleRecurring;

  const TimeBlockCard({
    Key? key,
    required this.block,
    required this.onDelete,
    required this.onToggleRecurring,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.formatted,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // Recurring tag
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: block.recurring
                        ? Colors.green.withOpacity(0.15)
                        : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    block.tagLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: block.recurring
                          ? Colors.green[700]
                          : Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Toggle switch
          Column(
            children: [
              Switch(
                value: block.recurring,
                onChanged: (_) => onToggleRecurring(),
                activeColor: Colors.blue,
              ),
              const Text(
                "Recurring",
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),

          const SizedBox(width: 6),

          // Delete icon
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
