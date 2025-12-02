import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  final Widget child;
  final double heightPercentage;
  final Color backgroundColor;

  const HeaderContainer({
    super.key,
    required this.child,
    this.heightPercentage = 0.3,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * heightPercentage,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: child,
    );
  }
}