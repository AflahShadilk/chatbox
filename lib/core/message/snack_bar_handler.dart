import 'package:chatbox/core/constant/appcolors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackBarType { error, success, warning, info }

class SnackBarHelper {
  SnackBarHelper._();

  static void show(
    String message, {
    SnackBarType type = SnackBarType.info,
    String? title,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    bool isDismissible = true,
  }) {
    final config = _getConfig(type);

    Get.snackbar(
      title ?? config.title,
      message,
      snackPosition: position,
      backgroundColor: config.backgroundColor,
      colorText: AppColors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: duration ?? const Duration(seconds: 3),
      icon: Icon(config.icon, color: AppColors.white),
      shouldIconPulse: true,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return _SnackBarConfig(
          title: 'Error',
          backgroundColor: AppColors.red, 
          icon: Icons.error_outline,
        );
      case SnackBarType.success:
        return _SnackBarConfig(
          title: 'Success',
          backgroundColor: AppColors.green,
          icon: Icons.check_circle_outline,
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          title: 'Warning',
          backgroundColor:AppColors.orange,
          icon: Icons.warning_amber_outlined,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          title: 'Info',
          backgroundColor:AppColors.blue,
          icon: Icons.info_outline,
        );
    }
  }

  static void error(String message, {String? title}) =>
      show(message, type: SnackBarType.error, title: title);

  static void success(String message, {String? title}) =>
      show(message, type: SnackBarType.success, title: title);

  static void warning(String message, {String? title}) =>
      show(message, type: SnackBarType.warning, title: title);

  static void info(String message, {String? title}) =>
      show(message, type: SnackBarType.info, title: title);
}

class _SnackBarConfig {
  final String title;
  final Color backgroundColor;
  final IconData icon;

  _SnackBarConfig({
    required this.title,
    required this.backgroundColor,
    required this.icon,
  });
}
