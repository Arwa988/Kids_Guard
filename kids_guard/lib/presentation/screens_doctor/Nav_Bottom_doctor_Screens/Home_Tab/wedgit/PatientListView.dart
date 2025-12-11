import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Home_Tab/patient_details.dart';

class Patientlistview extends StatelessWidget {
  String patientName;

  String SicknessName;
  Patientlistview({required this.patientName, required this.SicknessName});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 14),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(PatientDetails.routname);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/hana.png"),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  Text(
                    SicknessName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: AppColors.kPrimaryColor,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
