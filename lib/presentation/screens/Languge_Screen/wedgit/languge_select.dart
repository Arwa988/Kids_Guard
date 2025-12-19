import 'package:flutter/material.dart';

class LangugeSelect extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const LangugeSelect({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Left side
            Row(
              children: [
                const SizedBox(width: 15),
                Icon(
                  icon,
                  color: isSelected ? selectedColor : Colors.grey.shade600,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "Lexend",
                    color: isSelected ? selectedColor : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            /// Check Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              child: isSelected
                  ? Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: selectedColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedColor, width: 1.2),
                      ),
                      child: Icon(Icons.check, color: selectedColor, size: 14),
                    )
                  : const SizedBox(width: 22, height: 22),
            ),
          ],
        ),
      ),
    );
  }
}
