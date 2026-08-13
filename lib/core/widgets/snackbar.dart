import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void sucess(String message) {
    _show(
      title: 'Sucesso',
      message: message,
      color: Colors.green,
      icon: Icons.check_circle,
      duration: const Duration(seconds: 3),
    );
  }

  static void error(String message) {
    _show(
      title: 'Erro',
      message: message,
      color: Colors.red,
      icon: Icons.error,
      duration: const Duration(seconds: 5),
    );
  }

  static void warning(String message) {
    _show(
      title: 'Aviso',
      message: message,
      color: Colors.orange,
      icon: Icons.warning,
      duration: const Duration(seconds: 4),
    );
  }


  // Chatgpt
  static void _show({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
    required Duration duration,
  }) {
    Get.snackbar(
      title,
      message,

      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,

      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      maxWidth: 500,

      backgroundColor: color,
      colorText: Colors.white,

      icon: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),

      duration: duration,

      animationDuration: const Duration(
        milliseconds: 450,
      ),

      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,

      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}