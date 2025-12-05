import 'package:flutter/material.dart';
import '../../../../../../core/constants/App_Colors.dart';
import '../models/time_block.dart';
import 'time_block_card.dart';

class DayRow extends StatelessWidget {
  final String dayName;
  final List<TimeBlock> blocks;
  final VoidCallback onAddBlock;
  final void Function(int index) onDeleteBlock;
  final void Function(int index) onToggleRecurring;

  const DayRow({
    Key? key,
    required this.dayName,
    required this.blocks,
    required this.onAddBlock,
    required this.onDeleteBlock,
    required this.onToggleRecurring,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day + add button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50),

            // Small grey circle with white plus
            GestureDetector(
              onTap: onAddBlock,
              child: Container(
                height: 23,
                width: 90,
                decoration: const BoxDecoration(
                  color: AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Time blocks
        ...blocks.asMap().entries.map((entry) {
          final index = entry.key;
          final block = entry.value;

          return TimeBlockCard(
            block: block,
            onDelete: () => onDeleteBlock(index),
            onToggleRecurring: () => onToggleRecurring(index),
          );
        }),
      ],
    );
  }
}
