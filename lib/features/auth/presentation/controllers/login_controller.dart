import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/features/auth/data/services/auth_service.dart';
import 'package:tomora/routes/app_routes.dart';

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

    try {
    final authService = Get.find<AuthService>();

    // 1. Faz login e salva o token
    await authService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    // 2. Busca os dados do usuário
    final user = await authService.getMe();

    // 3. Navega de acordo com o role
    if (user.role == 'MEDICADO') {
      Get.offAllNamed(AppRoutes.screenMedicado);
    } else if (user.role == 'AUXILIAR') {
      Get.offAllNamed(AppRoutes.screenAuxiliar);
    } else {
      throw Exception('Tipo de conta desconhecido');
    }
  } catch (e) {
    print('======= ERRO NO LOGIN =======');
  print(e);
  print('=============================');
    errorMessage.value = e.toString().replaceAll('Exception: ', '');
  } finally {
    loading.value = false;
  }
}
  }
