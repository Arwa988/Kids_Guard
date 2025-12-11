import 'package:flutter/material.dart';

class PatientTextInfo extends StatelessWidget {
  final String text;
  final String info;

  const PatientTextInfo({super.key, required this.text, required this.info});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[900], // لون عنوان المعلومات
        ),
        children: [
          TextSpan(text: text),
          TextSpan(
            text: info,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade600, // 👈 لون modern جميل وواضح
            ),
          ),
        ],
      ),
    );
  }
}
