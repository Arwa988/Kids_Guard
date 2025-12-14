// import 'package:flutter/material.dart';

// import '../../../../../../core/constants/App_Colors.dart';

// class DoctorHeader extends StatelessWidget {
//   const DoctorHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(7),
//           child: AspectRatio(
//             aspectRatio: 19 / 20, // or whatever the actual ratio of your image is
//             child: Image.asset('assets/images/diagnosis.png',
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),

//         Positioned(
//           left: 24,
//           right: 24,
//           bottom: -30,
//           child: Container(
//             height: 66,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: const LinearGradient(
//                 colors: [AppColors.lightBlue, AppColors.HomeScreenBg],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 6))
//               ],
//             ),
//             child: const Text(
//               "Dr. Ali Uzair",
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
