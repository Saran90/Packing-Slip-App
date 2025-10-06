import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.label,
      required this.onSubmit,
      required this.startColor,
      required this.endColor,
      this.fontSize = 18})
      : super(key: key);

  final Function()? onSubmit;
  final Color startColor;
  final Color endColor;
  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSubmit,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [startColor,endColor]
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.white,
                width: 1
            )
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
