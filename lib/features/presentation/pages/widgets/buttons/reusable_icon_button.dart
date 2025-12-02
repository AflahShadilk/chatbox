import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:flutter/material.dart';

//  Reusable circular icon button
class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double size;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.white,
    this.backgroundColor,
    this.borderColor,
    this.size = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      width: size,
      height: size,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }
}