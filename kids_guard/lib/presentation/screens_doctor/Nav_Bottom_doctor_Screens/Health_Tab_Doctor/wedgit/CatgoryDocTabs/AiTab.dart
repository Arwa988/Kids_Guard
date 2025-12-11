import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerList.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Grib_View_Doc/AiGrib.dart';

class Aitab extends StatelessWidget {
  const Aitab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // 🔹 BlocBuilder for AI & Emerging Technologies
          BlocBuilder<HealthdocModel, HealthdocState>(
            buildWhen: (previous, current) =>
                current is AISucessState || current is AILoadingState,
            builder: (context, state) {
              if (state is AISucessState) {
                final articles = context.read<HealthdocModel>().AiList;
                return Aigrib(AIList: articles ?? []);
              }

              // 🔹 Shimmer while loading
              return const ShimmerList(count: 4);
            },
          ),
        ],
      ),
    );
  }
}
