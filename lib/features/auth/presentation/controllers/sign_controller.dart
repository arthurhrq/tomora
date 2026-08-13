import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/auth/data/services/auth_service.dart';
import 'package:tomora/routes/app_routes.dart';

class SignController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final roleController = ''.obs;
  final loading = false.obs;
  final errorMessage = ''.obs;
  final obscurepassword = true.obs;

  void toggleObscurePassword() {
    obscurepassword.value = !obscurepassword.value;
  }

  Future<void> sign() async {
  errorMessage.value = '';
  loading.value = true;

  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;
  final role = roleController.value.trim();

  if (name.isEmpty) {
    AppSnackbar.error('O campo de nome é obrigatório.');
    loading.value = false;
    return;
  }

  if (email.isEmpty) {
    AppSnackbar.error('O campo de email é obrigatório.');
    loading.value = false;
    return;
  }

  if (password.isEmpty) {
    AppSnackbar.error('O campo de senha é obrigatório.');
    loading.value = false;
    return;
  }

  if (role.isEmpty) {
    AppSnackbar.error('O campo de função é obrigatório.');
    loading.value = false;
    return;
  }

  try {
    final authService = Get.find<AuthService>();

    // 1. Cria a conta
    await authService.signUp(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    // 2. Faz login para obter o token
    await authService.login(
      email: email,
      password: password,
    );

    // 3. Busca os dados do usuário recém-criado
    final user = await authService.getMe();

    print('======= USUÁRIO CRIADO =======');
    print('ID: ${user.id}');
    print('Nome: ${user.name}');
    print('Email: ${user.email}');
    print('Role: ${user.role}');
    print('==============================');

    AppSnackbar.sucess('Conta criada com sucesso!');

    // 4. Limpa os campos
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    roleController.value = '';

    // 5. Envia o ID para a próxima tela
    Get.toNamed(
      AppRoutes.screenMedicado,
      arguments: user.id,
    );
  } catch (e) {
    print('======= ERRO AO CRIAR CONTA =======');
    print(e);
    print('===================================');

    errorMessage.value =
        e.toString().replaceAll('Exception: ', '');

    AppSnackbar.error('Erro ao criar conta');
  } finally {
    loading.value = false;
  }
}
}