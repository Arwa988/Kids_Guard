import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/guardin_select.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/real_time_monitoring_screen.dart';
import 'package:kids_guard/presentation/screens_doctor/Onboarding_Screens/real_time_monitoring_doctor_screen.dart';

class GuardinScreen extends StatelessWidget {
  static const String routname = "/select_guardin";

  // ✅ المفتاح للوصول إلى حالة GuardinSelect
  final GlobalKey<GuardinSelectState> guardianKey =
      GlobalKey<GuardinSelectState>();

  GuardinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CloudDesgin(),
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
                      "Pick One",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Lexend",
                        color: AppColors.splashScreenLinearBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ✅ اربط الـ widget بالمفتاح
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GuardinSelect(key: guardianKey),
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
                    final selectedIndex = guardianKey
                        .currentState
                        ?.selectedIndex; // ✅ نقرأ القيمة
                    // read el choice ely anty a5trtyh

                    if (selectedIndex == 0) {
                      Navigator.pushReplacementNamed(
                        context,
                        RealTime.routname,
                      );
                    } else if (selectedIndex == 1) {
                      Navigator.pushReplacementNamed(
                        context,
                        RealTimeDoctor.routname,
                      );
                    }
                  },
                  child: Text(
                    "Next",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
