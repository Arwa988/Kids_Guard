import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_model.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/CatogoryTabs/EmergencyTab.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/CatogoryTabs/HeartTab.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/wedgit/CatogoryTabs/LifeStyleTab.dart';

class HealthTab extends StatefulWidget {
  static const String routname = "health";

  @override
  State<HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends State<HealthTab> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final HealthTabModel viewModel = HealthTabModel();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.kLightBlue,
          toolbarHeight: 20,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
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
              Tab(text: "First Aids"),
              Tab(text: "Heart\nHealth"),
              Tab(text: "Lifestyle"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColors.background,
          ),
          child: TabBarView(
            children: [
              BlocProvider(
                create: (_) => HealthTabModel()..getAllEmergency(),
                child: EmergencyTab(),
              ),
              BlocProvider(
                create: (_) => HealthTabModel()..getAllArticles(),
                child: Hearttab(),
              ),
              BlocProvider(
                create: (_) => HealthTabModel()..getAllLifeStyle(),
                child: Lifestyletab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
