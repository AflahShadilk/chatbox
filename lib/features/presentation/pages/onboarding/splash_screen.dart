import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:chatbox/features/presentation/pages/navigation/navigation_page.dart';
import 'package:chatbox/features/presentation/pages/onboarding/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> navigateAfterLoad() async {
    final pref = await SharedPreferences.getInstance();
    final userLogin = pref.getBool("saveKey") ?? false;

    if (!mounted) return;
    
    if (!userLogin) {
      Get.offAll(()=>const  WelcomePage());
    } else {
      Get.offAll(()=> NavigationPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: LottieBuilder.asset(
          'assets/animations/Live chatbot.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() {
                navigateAfterLoad();
              });
          },
        ),
      ),
    );
  }
}