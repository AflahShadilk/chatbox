// ignore_for_file: deprecated_member_use

import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:chatbox/core/message/snack_bar_handler.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:chatbox/features/presentation/pages/navigation/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GoogleAuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.black,
              AppColors.deepPurple, // replaced 0xFF8A2BE2
              AppColors.purple,     // replaced 0xFF4B0082
              AppColors.black,
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: AppColors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  'Enter Your Phone Number',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This helps your friends find you on the app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: '+91 1234567890',
                    hintStyle: TextStyle(
                      color: AppColors.white.withOpacity(0.54),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: AppColors.white,
                    ),
                    filled: true,
                    fillColor: AppColors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : () => _savePhoneNumber(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.offAll(() => NavigationPage()),
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePhoneNumber() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      SnackBarHelper.warning('Please enter your phone number');
      return;
    }

    if (!_isValidPhoneNumber(phone)) {
      SnackBarHelper.error('Please enter a valid phone number');
      return;
    }

    await authController.updatePhoneNumber(phone);
    Get.offAll(() => NavigationPage());
  }

  bool _isValidPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return cleaned.length >= 10;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
