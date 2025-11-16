import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerList.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Grib_View_Doc/MedicalGrib.dart';

class Medicaltab extends StatelessWidget {
  const Medicaltab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // 🔹 BlocBuilder for Case Studies & Medical Guidelines
          BlocBuilder<HealthdocModel, HealthdocState>(
            buildWhen: (previous, current) =>
                current is MedicalTabSucessState ||
                current is MedicaldocLoadingState,
            builder: (context, state) {
              if (state is MedicalTabSucessState) {
                final articles = context.read<HealthdocModel>().MedicalList;
                return Medicalgrib(MedicalDataList: articles ?? []);
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
