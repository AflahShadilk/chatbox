import 'package:flutter/material.dart';

class CurvedContainer extends StatelessWidget {
  final Widget child;
  final double topPosition;
  final double borderRadius;
  final Color backgroundColor;

  const CurvedContainer({
    super.key,
    required this.child,
    required this.topPosition,
    this.borderRadius = 30,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
          color: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}