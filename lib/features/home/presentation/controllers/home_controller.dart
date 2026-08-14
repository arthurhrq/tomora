import 'dart:async';

import 'package:get/get.dart';
import 'package:tomora/core/services/alarm_service.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/features/home/data/models/history_model.dart';
import 'package:tomora/features/home/data/models/reminder_model.dart';
import 'package:tomora/features/home/data/repository/reminder_repository.dart';

class HomeController extends GetxController {
  final ReminderRepository repository;

  HomeController(this.repository);

  final reminders = <ReminderModel>[].obs;
  final histories = <HistoryModel>[].obs;

  final isLoading = false.obs;

  final userIds = <int>[];

  /// De quanto em quanto tempo o Diário busca atualizações no banco
  /// (ex: um lembrete que o cuidador acabou de cadastrar remotamente).
  static const _pollingInterval = Duration(seconds: 15);
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    loadHome();
    _startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  /// Liga a atualização automática em segundo plano. Cada "tick" busca
  /// os lembretes/histórico atuais e reagenda os alarmes locais deste
  /// aparelho, sem mostrar o spinner de carregamento (pra não interromper
  /// quem já está olhando a tela).
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      _fetchAndSync(showLoading: false);
    });
  }

  /// Carregamento "manual" (chamado no onInit, no botão de refresh e após
  /// ações do usuário). Mostra o spinner de tela cheia.
  Future<void> loadHome() => _fetchAndSync(showLoading: true);

  /// Núcleo do carregamento: busca lembretes + histórico de hoje para os
  /// usuários relevantes (o próprio usuário, e o cuidador/medicado
  /// vinculado, quando houver) e reagenda os alarmes locais deste
  /// aparelho de acordo com o que veio do banco.
  Future<void> _fetchAndSync({required bool showLoading}) async {
    try {
      if (showLoading) isLoading.value = true;

      final currentUser = Get.find<UserController>().user;

      userIds.clear();

      final currentUserId = int.parse(currentUser.id);

      userIds.add(currentUserId);

      if (currentUser.role == 'MEDICADO') {
        if (currentUser.caregiverId != null) {
          userIds.add(
            int.parse(currentUser.caregiverId!),
          );
        }
      }

      if (currentUser.role == 'AUXILIAR') {
        final medicados = await getMedicadosDoAuxiliar(
          currentUserId,
        );

        userIds.addAll(medicados);
      }

      reminders.value = await repository.getRemindersForUsers(
        userIds,
      );

      histories.value = await repository.getTodayHistory(
        userIds,
      );

      // Reagenda os alarmes locais deste aparelho de acordo com os
      // lembretes atuais (garante que o alarme sempre reflita o banco,
      // inclusive lembretes cadastrados remotamente pelo cuidador).
      await Get.find<AlarmService>().rescheduleAll(reminders);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<List<int>> getMedicadosDoAuxiliar(
    int auxiliarId,
  ) async {
    final response = await repository.supabase
        .from('User')
        .select('id')
        .eq('caregiverId', auxiliarId)
        .eq('role', 'MEDICADO');

    return (response as List)
        .map<int>((json) => json['id'] as int)
        .toList();
  }

  /// Calcula o status visual de um lembrete (pending / taken / missed)
  /// cruzando o lembrete com o histórico de hoje já carregado.
  ReminderStatus getReminderStatus(ReminderModel reminder) {
    HistoryModel? history;

    for (final h in histories) {
      if (h.reminderId == reminder.id) {
        history = h;
        break;
      }
    }

    if (history != null) {
      return history.taken
          ? ReminderStatus.taken
          : ReminderStatus.missed;
    }

    final now = DateTime.now();
    final scheduled = _scheduledDateTimeFor(reminder, now);

    if (now.isAfter(scheduled)) {
      return ReminderStatus.missed;
    }

    return ReminderStatus.pending;
  }

  /// Marca o lembrete como tomado agora (botão verde na Home).
  Future<void> markAsTaken(ReminderModel reminder) async {
    try {
      final currentUser = Get.find<UserController>().user;
      final scheduledFor = _scheduledDateTimeFor(
        reminder,
        DateTime.now(),
      );

      await repository.recordHistory(
        userId: int.parse(currentUser.id),
        reminderId: reminder.id,
        scheduledFor: scheduledFor,
        taken: true,
      );

      AppSnackbar.sucess('Lembrete marcado como tomado!');
      await loadHome();
    } catch (e) {
      AppSnackbar.error('Erro ao atualizar o lembrete');
    }
  }

  /// Exclui (desativa) o lembrete e cancela o alarme local dele.
  Future<void> deleteReminder(ReminderModel reminder) async {
    try {
      await repository.deleteReminder(reminder.id);
      await Get.find<AlarmService>().cancelReminder(reminder.id);

      AppSnackbar.sucess('Lembrete excluído.');
      await loadHome();
    } catch (e) {
      AppSnackbar.error('Erro ao excluir o lembrete');
    }
  }

  DateTime _scheduledDateTimeFor(ReminderModel reminder, DateTime base) {
    final parts = reminder.time.split(':');
    return DateTime(
      base.year,
      base.month,
      base.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}