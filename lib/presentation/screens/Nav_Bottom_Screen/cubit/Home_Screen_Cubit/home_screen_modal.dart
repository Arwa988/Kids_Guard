import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/health_tab.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/home_screen_tab.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Schedule_Tab/schedule_tab.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Tracker_Tab/tracker_tab.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/cubit/Home_Screen_Cubit/home_screen_state.dart';

class HomeScreenModal extends Cubit<HomeSceenState> {
  HomeScreenModal() : super(HomescreenIntialstate());

  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreenTab(),
    TrackerTab(),
    HealthTab(),
    ScheduleTab(),
  ];

  void changeIndex(int index) {
    // Change selected index first
    selectedIndex = index;

    // Emit loading state
    emit(HomescreenLoadingstate());

    // Delay slightly to show loading before updating
    Future.delayed(const Duration(milliseconds: 800), () {
      emit(ChangeSelectedIndexState());
    });
  }
}
