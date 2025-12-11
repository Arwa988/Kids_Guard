import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loadingdesgin extends StatelessWidget {
  const Loadingdesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 105,
          height: 100,
          alignment: Alignment.center,
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColors.textSecondary,
            size: 40,
          ),
        ),
      ),
    );
  }
}
