import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/DashBoard_patient.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/heart_animation.dart';

class HealthMetric extends StatelessWidget {
  const HealthMetric({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.HomeScreenBodybg,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //  Heart rate
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB4B4).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text("Heart Beats"),
                      Row(
                        children: [
                          Text(
                            "89 ",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge?.copyWith(fontSize: 50),
                          ),
                          const Text("bpm"),
                        ],
                      ),
                    ],
                  ),
                  HeartAnimation(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          //  Blood pressure + oxygen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Expanded(
                  child: DashboardPatient(
                    perecenetage: "95%",
                    symbol: "SP02",
                    text: "Blood Oxgyen",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Expanded(
                  child: DashboardPatient(
                    perecenetage: "100/75",
                    symbol: "mmHg",
                    text: "Blood Pressure",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
