import 'package:alarm/alarm.dart';
import 'package:get/get.dart';
import 'package:tomora/core/services/alarm_service.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/features/home/data/repository/reminder_repository.dart';

class AlarmRingController extends GetxController {
  final int alarmId;
  final String title;
  final String body;
  final DateTime scheduledFor;

  AlarmRingController({
    required this.alarmId,
    required this.title,
    required this.body,
    required this.scheduledFor,
  });

  final loading = false.obs;

  ReminderRepository get _repository => Get.find<ReminderRepository>();
  AlarmService get _alarmService => Get.find<AlarmService>();

  /// Botão "Sim" - registra como tomado e para o alarme.
  Future<void> confirmTaken() async {
    await _respond(taken: true);
  }

  /// Botão "Não" - registra como não tomado e para o alarme.
  Future<void> confirmNotTaken() async {
    await _respond(taken: false);
  }

  Future<void> _respond({required bool taken}) async {
    if (loading.value) return;
    loading.value = true;

    try {
      final userId = int.parse(Get.find<UserController>().user.id);

      await _repository.recordHistory(
        userId: userId,
        reminderId: alarmId,
        scheduledFor: scheduledFor,
        taken: taken,
      );

      await Alarm.stop(alarmId);

      Get.back();
    } catch (e) {
      AppSnackbar.error('Erro ao registrar resposta do alarme');
    } finally {
      loading.value = false;
    }
  }

  /// Botão "Adiar" - toca de novo daqui a 5 minutos, sem gravar histórico.
  Future<void> snooze() async {
    if (loading.value) return;
    loading.value = true;

    try {
      await _alarmService.snooze(alarmId, title: title, body: body);
      Get.back();
    } catch (e) {
      AppSnackbar.error('Erro ao adiar o alarme');
    } finally {
      loading.value = false;
    }
  }
}