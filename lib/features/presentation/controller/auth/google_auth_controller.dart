import 'package:chatbox/core/message/snack_bar_handler.dart';
import 'package:chatbox/features/domain/entities/auth/google_entities.dart';
import 'package:chatbox/features/domain/usecases/auth/google_sign_in_usecase.dart';
import 'package:chatbox/features/domain/usecases/auth/google_sign_out_usecase.dart';
import 'package:chatbox/features/presentation/pages/navigation/navigation_page.dart';
import 'package:chatbox/features/presentation/pages/onboarding/welcome_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthController extends GetxController {
  final GoogleSignInUsecase signInUsecase;
  final GoogleSignOutUsecase signOutUsecase;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<GoogleEntities?> currentUser = Rx<GoogleEntities?>(null);
  GoogleAuthController(this.signInUsecase, this.signOutUsecase);

  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      final user = await signInUsecase.call();
      if (user != null) {
        currentUser.value = GoogleEntities(
            userId: user.userId,
            email: user.email,
            name: user.name,
            photoUrl: user.photoUrl);
        final pref = await SharedPreferences.getInstance();
        await pref.setBool("saveKey", true);
        SnackBarHelper.success('Login Successful!');
        Get.offAll(() => NavigationPage());
      } else {
        SnackBarHelper.warning('Sign-in was cancelled');
      }
    } catch (e) {
      SnackBarHelper.error('Sign-in failed!');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await signOutUsecase.signOut();
      final pref = await SharedPreferences.getInstance();
      await pref.setBool("saveKey", false);

      SnackBarHelper.success('Logged out successfully');
      Get.offAll(() => const WelcomePage());
    } catch (e) {
      SnackBarHelper.error('Sign-out failed!');
    }
  }
}
