import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/PatientListView.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/home_screen_doctor.dart';

class PatientList extends StatelessWidget {
  static const String routname = "/patient_list";
  List<String> PatientsNames = ["Hana Walid", "Jana Hassen", "Mariam Omar"];
  List<String> SicknessNames = [
    "Cardiac Arrhythmia",
    "Cyanotic Arrhythmia",
    "Cardiac Arrhythmia",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // Set the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, -3), // Position of the shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColors.kTextColor,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(HomeScreenDoctor.routname);
              },
              icon: Icon(Icons.arrow_back, color: AppColors.background),
            ),
            title: Text(
              "Patient List",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: AppColors.background),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Patientlistview(
            patientName: PatientsNames[index],
            SicknessName: SicknessNames[index],
          );
        },
      ),
    );
  }
}
