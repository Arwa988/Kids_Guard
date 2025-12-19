import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/guardin_select.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/real_time_monitoring_doctor_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/real_time_monitoring_screen.dart';

class GuardinScreen extends StatefulWidget {
  const GuardinScreen({super.key});
  static const String routname = "/select_guardin";

  @override
  State<GuardinScreen> createState() => _GuardinScreenState();
}

class _GuardinScreenState extends State<GuardinScreen> {
  int? selectedIndex; // No default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const CloudDesgin(),
          Align(
            alignment: AlignmentDirectional.center,
            child: Container(
              width: 309,
              height: 288,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pick_one,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Lexend",
                        color: AppColors.splashScreenLinearBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildOption(
                      index: 0,
                      label: AppLocalizations.of(context)!.guardian,
                      icon: Icons.family_restroom,
                      selectedColor: const Color(0xFFFFC0CB), // Baby Pink
                    ),
                    const SizedBox(height: 20),
                    _buildOption(
                      index: 1,
                      label: AppLocalizations.of(context)!.doctor,
                      icon: Icons.medical_information,
                      selectedColor: const Color(0xFFADD8E6), // Baby Blue
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 91,
                height: 49,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedIndex == 0) {
                      Navigator.pushNamed(context, RealTime.routname);
                    } else if (selectedIndex == 1) {
                      Navigator.pushNamed(context, RealTimeDoctor.routname);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select Guardian or Doctor first',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.next,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Lexend",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required int index,
    required String label,
    required IconData icon,
    required Color selectedColor,
  }) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
