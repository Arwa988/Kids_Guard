import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/Guardin_Screen.dart';
import 'package:kids_guard/presentation/screens/Guardin_Screen/wedgit/cloud_desgin.dart';
import 'package:kids_guard/presentation/screens/Languge_Screen/wedgit/languge_select.dart';

class LangugeScreen extends StatelessWidget {
  static const String routname = "/languge";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CloudDesgin(),
          Align(
            alignment: AlignmentDirectional.center, // <-- SEE HERE
            child: Container(
              width: 309,
              height: 288,

              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.normal,
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: Offset(0, 3),
                    color: Colors.grey,
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
                      "Choose a Language",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Lexend",
                        color: AppColors.splashScreenLinearBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    LangugeSelect(text: "English"),
                    SizedBox(height: 20),
                    LangugeSelect(text: "Arabic"),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 91,
                height: 49,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(GuardinScreen.routname);
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
