// ignore_for_file: deprecated_member_use

import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:chatbox/features/presentation/controller/pages/navigation_controller.dart';
import 'package:chatbox/features/presentation/pages/screens/chat_screen.dart';
import 'package:chatbox/features/presentation/pages/screens/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  final NavigationController navCntrl = Get.put(NavigationController());

  final List<Widget> screens = [
    ChatScreen(),
    ContactsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: navCntrl.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: AppColors.black.withOpacity(0.05),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chats',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.group_rounded,
                label: 'Contacts',
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = navCntrl.selectedIndex.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => navCntrl.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.darkBlue : AppColors.grey,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: isSelected ? AppColors.darkBlue : AppColors.grey,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}