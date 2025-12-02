import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:chatbox/features/presentation/pages/widgets/buttons/reusable_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;

  const ChatTopBar({
    super.key,
    required this.title,
    required this.onSearchPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularIconButton(
            icon: Icons.search_outlined,
            onPressed: onSearchPressed,
            borderColor: AppColors.white,
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          CircularIconButton(
            icon: Icons.person,
            onPressed: onProfilePressed,
            backgroundColor: AppColors.blue,
            iconColor: AppColors.amber,
          ),
        ],
      ),
    );
  }
}