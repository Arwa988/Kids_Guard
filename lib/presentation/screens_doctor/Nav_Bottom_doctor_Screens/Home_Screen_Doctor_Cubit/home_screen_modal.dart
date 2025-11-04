import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Chat_Tab/chat_tab.dart';

import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/health_tab_doc.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Screen_Doctor_Cubit/home_screen_state.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/home_tab.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Schedule_Tab_Doctor/schedule_tab.dart';

class HomeScreenModalDoctor extends Cubit<HomeSceenDocState> {
  HomeScreenModalDoctor() : super(HomescreenDocIntialstate());
  // hold data   handle logic
  int selectedIndex = 0;
  List<Widget> screens = [
    HomeTabDoctor(),
    HealthTabDoctor(),
    ScheduleTabDoctor(),
    ChatTab(),
  ];
 
 void changeIndex(int index) {
  // غيّري المؤشر أولاً
  selectedIndex = index;

  // فعّلي حالة الـ Loading
  emit(HomescreenDocLoadingstate());

  // بعد شوية (مثلاً 800ms)، اعرض الشاشة الجديدة
  Future.delayed(const Duration(milliseconds: 800), () {
    emit(ChangeSelectedDocIndexState());
  });
}
}
