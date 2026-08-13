import 'package:get/get.dart';
import 'package:tomora/features/home/data/models/history_model.dart';
import 'package:tomora/features/home/data/models/reminder_model.dart';
import 'package:tomora/features/home/data/repository/reminder_repository.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';

class HomeController extends GetxController {
  final ReminderRepository repository;

  HomeController(this.repository);

  final reminders = <ReminderModel>[].obs;
  final histories = <HistoryModel>[].obs;

  final isLoading = false.obs;

  final userIds = <int>[];

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  Future<void> loadHome() async {
    try {
      isLoading.value = true;

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
    } finally {
      isLoading.value = false;
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

    // Sem registro no histórico ainda: verifica se já passou do horário.
    final now = DateTime.now();
    final parts = reminder.time.split(':');

    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (now.isAfter(scheduled)) {
      return ReminderStatus.missed;
    }

    return ReminderStatus.pending;
  }
}