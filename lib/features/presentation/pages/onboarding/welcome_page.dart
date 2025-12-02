import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:chatbox/features/presentation/controller/auth/google_auth_controller.dart';
import 'package:chatbox/features/presentation/pages/widgets/textstyles/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final GoogleAuthController controller = Get.find();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF8A2BE2),
              Color(0xFF4B0082),
              Color(0xFF000000),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: 'Connect',
                    fontSize: 60,
                    letterSpacing: 4,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: 'friends',
                    fontSize: 60,
                    letterSpacing: 4,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: 'easily &',
                    fontSize: 60,
                    letterSpacing: 4,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: 'quickly',
                    fontSize: 60,
                    letterSpacing: 4,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: 'Our chat app is the perfect way to stay',
                    fontSize: 15,
                    color: Color.fromARGB(197, 234, 233, 233),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ReusableText(
                    text: 'Connected with friends and family',
                    fontSize: 15,
                    color: Color.fromARGB(197, 234, 233, 233),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: GestureDetector(
                        onTap: () async {
                          controller.signInWithGoogle();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.white),
                            shape: BoxShape.circle,
                          ),
                          height: 60,
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Image.asset(
                              'assets/icons/google.png',
                            ),
                          ),
                        ),
                      ),
                    )),
            )
          ],
        ),
      ),
    );
  }
}
