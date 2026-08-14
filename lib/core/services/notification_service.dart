import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Centraliza a notificação de status bar (flutter_local_notifications)
/// disparada quando um alarme de lembrete começa a tocar.
///
/// É uma camada separada da notificação nativa do pacote `alarm`: aqui
/// garantimos que sempre aparece uma notificação "de verdade" na barra
/// de status, com o texto pedido, e que ao tocar nela o app é trazido
/// pra frente. Como o [AlarmService] escuta `Alarm.ringing`, assim que o
/// app volta a rodar (em foreground) a navegação pra tela do alarme
/// (AlarmRingPage) acontece sozinha — não precisamos tratar o toque na
/// notificação manualmente.
class NotificationService extends GetxService {
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'tomora_alarm_channel';
  static const _channelName = 'Alarmes de lembrete';
  static const _channelDescription =
      'Notificações mostradas quando um lembrete de remédio toca.';

  // Deslocamento grande somado ao id do lembrete/alarme antes de criar a
  // notificação. É ESSENCIAL: o pacote `alarm` usa o mesmo id do
  // lembrete pra gerenciar a notificação do foreground service dele no
  // Android — é esse serviço que mantém o som tocando, a vibração ativa
  // e o volume travado. Se a gente publicasse uma notificação com o
  // MESMO id por aqui, ela substituiria a notificação do `alarm`, o
  // Android derrubaria o foreground service, e o alarme parava de tocar
  // som/vibrar/travar volume (só a notificação visual continuava
  // aparecendo). Somando esse offset, garantimos ids sempre diferentes.
  static const _idOffset = 900000000;

  /// Inicializa o plugin e pede as permissões necessárias.
  /// Deve ser chamado uma única vez, no main(), antes do runApp.
  Future<NotificationService> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      settings: initSettings,
      // Não precisamos navegar manualmente aqui: tocar na notificação já
      // basta pra reabrir/trazer o app pra frente, e o listener de
      // Alarm.ringing (em AlarmService) cuida do resto.
      onDidReceiveNotificationResponse: (_) {},
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return this;
  }

  /// Mostra a notificação de "alarme tocando" na barra de status.
  /// [id] deve ser o mesmo id do lembrete/alarme, pra dar pra
  /// cancelar/atualizar depois (ex: quando o usuário já respondeu).
  Future<void> showAlarmNotification({
    required int id,
    required String title,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: true,
      // O som/vibração já são tocados pelo pacote `alarm`; aqui é só a
      // notificação visual na barra de status.
      playSound: false,
      enableVibration: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: _idOffset + id,
      title: title,
      body: 'Toque para abrir o alarme',
      notificationDetails: details,
    );
  }

  /// Remove a notificação (ex: quando o usuário já respondeu ao alarme
  /// ou adiou pra tocar de novo mais tarde).
  Future<void> cancelAlarmNotification(int id) async {
    await _plugin.cancel(id: _idOffset + id);
  }
}