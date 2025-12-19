import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/core/constants/App_Colors.dart';
import 'package:kids_guard/l10n/app_localizations_ar.dart';
import 'package:kids_guard/l10n/app_localizations_en.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/Drawer_desgin.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/cubit/Home_Screen_Cubit/home_screen_modal.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/cubit/Home_Screen_Cubit/home_screen_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:kids_guard/l10n/app_localizations.dart';

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

          // Body with loading support
          body: state is HomescreenLoadingstate
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.textSecondary,
                    size: 40,
                  ),
                )
              : viewModal.screens[viewModal.selectedIndex],

          // Bottom Navigation Bar
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
              selectedIconTheme: const IconThemeData(
                color: AppColors.kTextColor,
              ),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: AppLocalizations.of(context)!.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.track_changes),
                  label: AppLocalizations.of(context)!.track,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.health_and_safety_outlined),
                  label: AppLocalizations.of(context)!.health,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: AppLocalizations.of(context)!.schedule,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
