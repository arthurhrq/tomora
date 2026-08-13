import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/features/home/data/repository/reminder_repository.dart';

class CreateReminderController extends GetxController {
  final ReminderRepository repository;

  CreateReminderController(this.repository);

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final descController = TextEditingController();

  // Valores iniciais parecidos com o design (18:01)
  final selectedHour = 18.obs;
  final selectedMinute = 1.obs;

  final loading = false.obs;

  void setHour(int value) => selectedHour.value = value;

  void setMinute(int value) => selectedMinute.value = value;

  String get _formattedTime {
    final h = selectedHour.value.toString().padLeft(2, '0');
    final m = selectedMinute.value.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> createReminder() async {
    // Trava contra duplo toque (mesmo problema que já resolvemos no sign)
    if (loading.value) return;

    final name = nameController.text.trim();
    final dosage = dosageController.text.trim();
    final desc = descController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.error('Informe o nome do medicamento.');
      return;
    }

    if (dosage.isEmpty) {
      AppSnackbar.error('Informe a dosagem.');
      return;
    }

    loading.value = true;

    try {
      final currentUser = Get.find<UserController>().user;

      await repository.createReminder(
        userId: int.parse(currentUser.id),
        name: name,
        dosage: dosage,
        desc: desc.isEmpty ? null : desc,
        time: _formattedTime,
      );

      AppSnackbar.sucess('Lembrete criado com sucesso!');
      Get.back();
    } catch (e) {
      print(e);
      AppSnackbar.error('Erro ao criar lembrete');
      print(e);
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    dosageController.dispose();
    descController.dispose();
    super.onClose();
  }
}