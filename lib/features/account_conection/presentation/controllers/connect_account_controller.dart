import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/account_conection/data/repository/connection_repository.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/routes/app_routes.dart';

class ConnectAccountController extends GetxController {
  final ConnectionRepository repository;

  ConnectAccountController(this.repository);

  final codeController = TextEditingController();
  final loading = false.obs;

  Future<void> connect() async {
    // Trava contra duplo toque
    if (loading.value) return;

    final code = codeController.text.trim();

    if (code.isEmpty) {
      AppSnackbar.error('Informe o código do medicado.');
      return;
    }

    final medicadoId = int.tryParse(code);

    if (medicadoId == null) {
      AppSnackbar.error('Código inválido.');
      return;
    }

    loading.value = true;

    try {
      final auxiliar = Get.find<UserController>().user;
      final auxiliarId = int.parse(auxiliar.id);

      final success = await repository.linkAccounts(
        auxiliarId: auxiliarId,
        medicadoId: medicadoId,
      );

      if (!success) {
        AppSnackbar.error(
          'Código não encontrado. Confira e tente novamente.',
        );
        return;
      }

      AppSnackbar.sucess('Contas conectadas com sucesso!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      AppSnackbar.error('Erro ao conectar contas');
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}