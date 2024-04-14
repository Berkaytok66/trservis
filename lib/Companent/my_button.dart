import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  final double fontSize;
  final FontWeight fontWeight;
  final double buttonWeight;
  final double buttonHeight;

  const MyButton({
    Key? key,
    required this.onTap,
    this.buttonColor = Colors.black,
    this.textColor = Colors.white,
    required this.buttonText,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.buttonWeight = 10,
    this.buttonHeight = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(buttonHeight),
        margin: EdgeInsets.symmetric(horizontal: buttonWeight),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
