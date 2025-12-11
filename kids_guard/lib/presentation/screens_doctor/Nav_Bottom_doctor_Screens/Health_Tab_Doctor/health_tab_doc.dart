import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/CatgoryDocTabs/AiTab.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/CatgoryDocTabs/FamilyTab.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/wedgit/CatgoryDocTabs/MedicalTab.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_Model.dart';

// ignore: must_be_immutable
class HealthTabDoctor extends StatefulWidget {
  static const String routname = "health_doc";

  @override
  State<HealthTabDoctor> createState() => _HealthTabDoctorState();
}

class _HealthTabDoctorState extends State<HealthTabDoctor> {
  HealthdocModel viewModel = HealthdocModel();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: AppColors.kTextColor,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.kLightBlue,
          toolbarHeight: 20,
          elevation: 0, // 👈 remove shadow that causes subtle line
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,

          // 💙 keep your cute curve
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          bottom: TabBar(
            labelColor: AppColors.background,
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            indicatorColor: AppColors.background,
            automaticIndicatorColorAdjustment: false,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontFamily: "Lexend",
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: "Case\nStudies"),
              Tab(text: "AI & Tech"),
              Tab(text: "Family\nSupport"),
            ],
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColors.background,
          ),

          child: TabBarView(
            children: [
              BlocProvider(
                create: (_) => HealthdocModel()..getAllMedical(),
                child: Medicaltab(),
              ),
              BlocProvider(
                create: (_) => HealthdocModel()..getAllAI(),
                child: Aitab(),
              ),
              BlocProvider(
                create: (_) => HealthdocModel()..getAllFamily(),
                child: Familytab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
