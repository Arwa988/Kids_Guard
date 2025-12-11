import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';

class CloudDesgin extends StatelessWidget {
  const CloudDesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.2,
          height: 297,
          decoration: BoxDecoration(
            color: AppColors.splashScreenLinearBlue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        Positioned(
          left: 29,
          top: 53,
          child: Image.asset("assets/images/cloud.png"),
        ),
        Positioned(
          top: 110,
          left: 260,
          right: 40,
          bottom: 113,
          child: Image.asset("assets/images/cloud.png"),
        ),
      ],
    );
  }
}
