import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Screen_Doctor_Cubit/home_screen_modal.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Screen_Doctor_Cubit/home_screen_state.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/home_tab.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/Drawer_desgin.dart';

// ignore: must_be_immutable
class HomeScreenDoctor extends StatelessWidget {
  static const String routname = "/home_screen_doctor";
  HomeScreenModalDoctor viewModal = HomeScreenModalDoctor();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenModalDoctor, HomeSceenDocState>(
      bloc: viewModal,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.HomeScreenBg,

          // ✅ Drawer for settings
          drawer: DrawerDesginDoctor(),

          body: viewModal.selectedIndex == 0
              ? HomeTabDoctor()
              : viewModal.screens[viewModal.selectedIndex],

          // 🔹 Bottom Navigation Bar
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.kTextColor,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                viewModal.changeIndex(index);
              },
              currentIndex: viewModal.selectedIndex,
              selectedIconTheme: const IconThemeData(
                color: AppColors.kTextColor,
              ),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

                BottomNavigationBarItem(
                  icon: Icon(Icons.health_and_safety_outlined),
                  label: "Health",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: "Schedule",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: "Chat",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
