import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/Drawer_desgin.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/cubit/Home_Screen_Cubit/home_screen_modal.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/cubit/Home_Screen_Cubit/home_screen_state.dart';

class HomeScreen extends StatelessWidget {
  static const String routname = "/home_screen";
  final HomeScreenModal viewModal = HomeScreenModal();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenModal, HomeSceenState>(
      bloc: viewModal,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.HomeScreenBg,
          drawer: DrawerDesgin(),

          // ✅ Show CircularProgressIndicator when loading
          body: state is HomescreenLoadingstate
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                    strokeWidth: 4,
                  ),
                )
              : viewModal.screens[viewModal.selectedIndex],

          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: viewModal.selectedIndex,
              onTap: (index) {
                viewModal.changeIndex(index);
              },
              selectedItemColor: AppColors.kTextColor,
              unselectedItemColor: Colors.grey,
              selectedIconTheme: IconThemeData(color: AppColors.kTextColor),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.track_changes),
                  label: "Tracker",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.health_and_safety_outlined),
                  label: "Health",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: "Schedule",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
