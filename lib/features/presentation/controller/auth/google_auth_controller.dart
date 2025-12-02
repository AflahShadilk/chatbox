import 'package:chatbox/core/message/snack_bar_handler.dart';
import 'package:chatbox/features/domain/entities/auth/google_entities.dart';
import 'package:chatbox/features/domain/usecases/auth/google_sign_in_usecase.dart';
import 'package:chatbox/features/domain/usecases/auth/google_sign_out_usecase.dart';
import 'package:chatbox/features/domain/usecases/auth/update_phone_number_usecase.dart';
import 'package:chatbox/features/presentation/pages/auth/phone_number_screen.dart';
import 'package:chatbox/features/presentation/pages/auth/welcome_page.dart';
import 'package:chatbox/features/presentation/pages/navigation/navigation_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthController extends GetxController {
  final GoogleSignInUsecase signInUsecase;
  final GoogleSignOutUsecase signOutUsecase;
  final UpdatePhoneNumberUsecase updatePhoneNumberUsecase;

  final isLoading = false.obs;
  final Rx<GoogleEntities?> currentUser = Rx<GoogleEntities?>(null);

  GoogleAuthController(
    this.signInUsecase,
    this.signOutUsecase,
    this.updatePhoneNumberUsecase,
  );

  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      final user = await signInUsecase.call();

      if (user != null) {
        currentUser.value = user;

        final pref = await SharedPreferences.getInstance();
        await pref.setBool("saveKey", true);

        if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
          SnackBarHelper.success('Welcome! Please add your phone number');
          Get.offAll(() => const PhoneNumberScreen());
        } else {
          SnackBarHelper.success('Login Successful!');
          Get.offAll(() => NavigationPage());
        }
      } else {
        SnackBarHelper.warning('Sign-in was cancelled');
      }
    } catch (e) {
      SnackBarHelper.error('Sign-in failed!');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    isLoading.value = true;

    try {
      final userId = currentUser.value?.userId;
      if (userId == null) throw Exception('User not logged in');

      final cleanedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

      await updatePhoneNumberUsecase.call(userId, cleanedPhone);

      currentUser.value = currentUser.value?.copyWith(phoneNumber: cleanedPhone);

      SnackBarHelper.success('Phone number added successfully!');
    } catch (e) {
      SnackBarHelper.error('Failed to save phone number');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await signOutUsecase.signOut();
      final pref = await SharedPreferences.getInstance();
      await pref.setBool("saveKey", false);

      currentUser.value = null;

      SnackBarHelper.success('Logged out successfully');
      Get.offAll(() => const WelcomePage());
    } catch (e) {
      SnackBarHelper.error('Sign-out failed!');
    }
  }
}
