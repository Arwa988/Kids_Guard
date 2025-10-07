import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/emergency_alerts_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/next_btn.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/animations/real_time_animation.dart';

class RealTime extends StatefulWidget {
  const RealTime({super.key});
  static const String routname = "/real_time";

  @override
  State<RealTime> createState() => _RealTimeState();
}

class _RealTimeState extends State<RealTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),

          Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/pinkblob.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: RealTimeAnimation(),
          ),
          SizedBox(height: 10),
          Text(
            "Real-Time Monitoring",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 5),
          Text(
            "Monitor heart rate, oxygen level,and \n      locations anytime, anywhere",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 10),
          NextBtn(routname: EmergencyAlerts.routname, text: "Next"),
          SizedBox(height: 29),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 100),
              Image(image: AssetImage("assets/images/ProgressIndicator.png")),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Create account",
                    style: Theme.of(context).textTheme.bodySmall,
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
