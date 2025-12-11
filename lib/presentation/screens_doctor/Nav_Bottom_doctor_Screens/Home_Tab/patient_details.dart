import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Home_Tab/wedgit/Health_metric.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/patient_list.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/wedgit/patient_text_info.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({super.key});
  static const String routname = "/patient_detailss";
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
                ).pushReplacementNamed(PatientList.routname);
              },
              icon: Icon(Icons.arrow_back, color: AppColors.background),
            ),
            title: Text(
              "Patient Details",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: AppColors.background),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage("assets/images/hannaa.png"),
                        ),
                      ),
                      SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hana Walid",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            PatientTextInfo(
                              text: "Disease:",
                              info: "Cyanotic Arrhythmia",
                            ),
                            PatientTextInfo(
                              text: "Medicine :",
                              info: "Metoprolol",
                            ),
                            PatientTextInfo(text: "Age :", info: "6 years"),
                            PatientTextInfo(text: "Gender : ", info: "Female "),
                            PatientTextInfo(text: "Surgery :", info: "No "),
                            PatientTextInfo(
                              text: "Phone:",
                              info: "01229451825",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: Text(
                  "Current Health",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              HealthMetric(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kLightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  ),
                  onPressed: () {
                    // TODO: navigator to Dashboard screen
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/bar-graph.png", width: 28),
                      SizedBox(width: 10),
                      Text(
                        "View Health Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
