import 'package:flutter/material.dart';
import 'package:kids_guard/presentation/screens/Languge_Screen/languge_screen.dart';
import 'package:kids_guard/presentation/screens/Onboarding_Screens/wedgit/next_btn.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String routname = "/welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 500,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/welcome.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(height: 47),
          Text(
            "Welcome to Kids Guard",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 40),
          NextBtn(routname: LangugeScreen.routname, text: "Get Started"),
          SizedBox(height: 130),
        ],
      ),
    );
  }
}
