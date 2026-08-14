import 'package:alarm/alarm.dart';
import 'package:get/get.dart';
import 'package:tomora/features/alarm/presentation/pages/alarm_ring_page.dart';
import 'package:tomora/features/home/data/models/reminder_model.dart';

/// Centraliza toda a integração com o pacote `alarm`: inicialização,
/// agendamento por lembrete, cancelamento e o listener global que abre
/// a tela de "o alarme está tocando" quando chega a hora.
class AlarmService extends GetxService {
  /// Inicializa o plugin e liga o listener global de "alarme tocando".
  /// Deve ser chamado uma única vez, no main(), antes do runApp.
  Future<void> init() async {
    await Alarm.init();
    _listenToRingingAlarms();
  }

  void _listenToRingingAlarms() {
    Alarm.ringing.listen((alarmSet) {
      for (final alarm in alarmSet.alarms) {
        Get.to(
          () => AlarmRingPage(
            alarmId: alarm.id,
            title: alarm.notificationSettings.title,
            body: alarm.notificationSettings.body,
            scheduledFor: alarm.dateTime,
          ),
        );
      }
    });
  }

  /// Calcula a próxima ocorrência de um horário "HH:mm" a partir de agora.
  /// Se o horário já passou hoje, agenda pra amanhã.
  DateTime nextOccurrence(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Agenda (ou reagenda, se já existir com o mesmo id) o alarme de
  /// um lembrete pra sua próxima ocorrência.
  Future<void> scheduleReminder(ReminderModel reminder) async {
    final dateTime = nextOccurrence(reminder.time);

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: reminder.id,
        dateTime: dateTime,
        assetAudioPath: null, // usa o som padrão de alarme do aparelho
        loopAudio: true,
        vibrate: true,
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 1.0,
          fadeDuration: const Duration(seconds: 3),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: 'Hora de tomar ${reminder.name}',
          body: 'Dosagem: ${reminder.dosage}',
          stopButton: 'Já tomei',
        ),
      ),
    );
  }

  /// Cancela o alarme local de um lembrete (ex: quando ele é excluído).
  Future<void> cancelReminder(int reminderId) async {
    await Alarm.stop(reminderId);
  }

  /// Reagenda todos os alarmes ativos de uma lista de lembretes.
  /// Chamado sempre que a Home recarrega, pra manter os alarmes deste
  /// aparelho sincronizados com o que está no banco.
  Future<void> rescheduleAll(List<ReminderModel> reminders) async {
    for (final reminder in reminders) {
      if (reminder.active) {
        await scheduleReminder(reminder);
      }
    }
  }

  /// Adia o alarme que está tocando por [delay] (padrão 5 minutos),
  /// mantendo o mesmo id/título/corpo.
  Future<void> snooze(
    int alarmId, {
    required String title,
    required String body,
    Duration delay = const Duration(minutes: 5),
  }) async {
    await Alarm.stop(alarmId);

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: alarmId,
        dateTime: DateTime.now().add(delay),
        assetAudioPath: null,
        loopAudio: true,
        vibrate: true,
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 1.0,
          fadeDuration: const Duration(seconds: 3),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: title,
          body: body,
          stopButton: 'Já tomei',
        ),
      ),
    );
  }
}