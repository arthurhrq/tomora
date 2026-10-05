import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/services/alarm_service.dart';
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

      // O lembrete sempre pertence ao MEDICADO.
      // Para MEDICADO, usamos o próprio ID. Para AUXILIAR, resolvemos
      // o ID do medicado através do vínculo caregiverId.
      final int reminderUserId;

      if (currentUser.role == 'MEDICADO') {
        reminderUserId = int.parse(currentUser.id);
      } else if (currentUser.role == 'AUXILIAR') {
        final medicados = await repository.getMedicadosDoAuxiliar(
          int.parse(currentUser.id),
        );

        if (medicados.isEmpty) {
          AppSnackbar.error(
            'Este cuidador não possui um medicado associado.',
          );
          return;
        }

        // Pela regra do app, todo cuidador que pode criar lembretes
        // possui um medicado associado.
        reminderUserId = medicados.first;
      } else {
        AppSnackbar.error('Usuário sem perfil válido para criar lembrete.');
        return;
      }

      final createdReminder = await repository.createReminder(
        userId: reminderUserId,
        name: name,
        dosage: dosage,
        desc: desc.isEmpty ? null : desc,
        time: _formattedTime,
      );

      // Só agenda o alarme LOCAL neste aparelho se quem está criando é a
      // conta MEDICADO. Quando é a conta AUXILIAR criando (de casa, por
      // ex.), o lembrete só é salvo no banco — o alarme de verdade é
      // montado no aparelho do medicado quando o dele sincroniza
      // (HomeController), pra não tocar nos dois dispositivos.
      if (currentUser.role == 'MEDICADO') {
        await Get.find<AlarmService>().scheduleReminder(createdReminder);
      }

      // Retorna automaticamente pra Home.
      Get.back();

      // Mostra a confirmação de sucesso já na Home.
      AppSnackbar.sucess('Lembrete criado com sucesso!');
    } catch (e) {
      AppSnackbar.error('Erro ao criar lembrete');
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