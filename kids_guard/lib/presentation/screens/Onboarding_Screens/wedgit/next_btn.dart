import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NextBtn extends StatelessWidget {
  String routname;
  String text;
  
  NextBtn({required this.routname, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 49,
      child: ElevatedButton(
        onPressed: () {

          Navigator.of(context).pushReplacementNamed(routname);
        },
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
