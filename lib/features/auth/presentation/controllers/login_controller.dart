import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/widgets/snackbar.dart';
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

    try {
    final authService = Get.find<AuthService>();

    // 1. Faz login e salva o token
    await authService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    // 2. Busca os dados do usuário
    final user = await authService.getMe();

    print('2 - getMe realizado');
    print('ID: ${user.id}');
    print('Nome: ${user.name}');
    print('Email: ${user.email}');
    print('Role: ${user.role}');
    print('Status: ${user.status}');


    // 3. Navega de acordo com o role
    if (user.role == 'MEDICADO') {
      AppSnackbar.sucess('Login realizado com sucesso!');
      Get.offAllNamed(AppRoutes.screenMedicado);
    } else if (user.role == 'AUXILIAR') {
      AppSnackbar.sucess('Login realizado com sucesso!');
      Get.offAllNamed(AppRoutes.screenAuxiliar);
    } else {
      throw Exception('Tipo de conta desconhecido');
    }
  } catch (e) {
    print('======= ERRO NO LOGIN =======');
  print(e);
  print('=============================');
    errorMessage.value = e.toString().replaceAll('Exception: ', '');
    AppSnackbar.error('Erro ao realizar login');
  } finally {
    loading.value = false;
  }
}
  }
