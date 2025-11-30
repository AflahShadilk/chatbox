import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableText extends StatelessWidget {
  const ReusableText(
      {super.key,
      required this.text,
      required this.color,
      required this.fontSize,
      this.fontWeight,
      this.letterSpacing});

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}