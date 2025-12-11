import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/wedgit/Loading_Desgin/ShimmerList.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/Grib_View_Doc/FamilyGrib.dart';

class Familytab extends StatelessWidget {
  const Familytab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // 🔹 BlocBuilder section
          BlocBuilder<HealthdocModel, HealthdocState>(
            buildWhen: (previous, current) =>
                current is FamilySucessState ||
                current is FamilyLoadingState, // ✅ fixed here
            builder: (context, state) {
              if (state is FamilySucessState) {
                final articles = context.read<HealthdocModel>().FamilyList;
                return Familygrib(FamilyList: articles ?? []);
              }

              // 🔹 Loading shimmer placeholder
              return const ShimmerList(count: 4);
            },
          ),
        ],
      ),
    );
  }
}
