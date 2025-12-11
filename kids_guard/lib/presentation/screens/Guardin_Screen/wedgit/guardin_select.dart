import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

class GuardinSelect extends StatefulWidget {
  const GuardinSelect({super.key});

  @override
  State<GuardinSelect> createState() => GuardinSelectState();
}


class GuardinSelectState extends State<GuardinSelect> {
  int? selectedIndex;

  final List<Map<String, String>> selectRole = [
    {"image": "assets/images/Gurard.png", "role": "Guardian"},
    {"image": "assets/images/Doctor.png", "role": "Doctor"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(selectRole.length, (index) {
        final option = selectRole[index];
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : Colors.grey.shade300,
                ),
                color: isSelected ? AppColors.lightBlue : Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image(image: AssetImage(option["image"]!)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      option["role"]!,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontFamily: "Lexend",
                            color: AppColors.splashScreenLinearBlue,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.splashScreenLinearBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
