import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/account_conection/data/repository/connection_repository.dart';
import 'package:tomora/features/auth/data/services/auth_service.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
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
    // Trava contra duplo toque
    if (loading.value) return;

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

      // 2.1 Guarda o usuário no UserController para o resto do app usar
      Get.find<UserController>().setUser(user);

      AppSnackbar.sucess('Login realizado com sucesso!');

      // 3. Decide pra onde ir de acordo com o role E se já está vinculado
      if (user.role == 'MEDICADO') {
        if (user.caregiverId != null) {
          // já tem um auxiliar vinculado -> vai direto pra home
          Get.offAllNamed(AppRoutes.home);
        } else {
          // ainda não vinculou ninguém -> mostra o código dele
          Get.offAllNamed(AppRoutes.screenMedicado, arguments: user.id);
        }
      } else if (user.role == 'AUXILIAR') {
        final connectionRepository = Get.find<ConnectionRepository>();

        final alreadyLinked = await connectionRepository
            .hasAuxiliarLinkedMedicados(int.parse(user.id));

        if (alreadyLinked) {
          // já tem pelo menos um medicado vinculado -> vai direto pra home
          Get.offAllNamed(AppRoutes.home);
        } else {
          // ainda não vinculou nenhum medicado -> pede o código
          Get.offAllNamed(AppRoutes.screenAuxiliar);
        }
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