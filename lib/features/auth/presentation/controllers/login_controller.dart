import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loading = false.obs;
  final errorMessage = ''.obs;
  final obscurepassword = true.obs;

  void toggleObscurePassword() {
    obscurepassword.value = !obscurepassword.value;
  }

  Future<void> login() async {
    errorMessage.value = '';
    loading.value = true;
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      errorMessage.value = 'O campo de email é obrigatório.';
      loading.value = false;
      return;
    }
    if (password.isEmpty) {
      errorMessage.value = 'O campo de senha é obrigatório.';
      loading.value = false;
      return;
    }
  }
}