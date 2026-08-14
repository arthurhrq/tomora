import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/primary_button.dart';
import 'package:tomora/features/alarm/presentation/controllers/alarm_ring_controller.dart';

/// Tela aberta automaticamente quando um alarme começa a tocar
/// (via AlarmService ouvindo Alarm.ringing). Não deixa o usuário sair
/// sem escolher uma opção — mesma lógica de um despertador de verdade.
class AlarmRingPage extends StatelessWidget {
  final int alarmId;
  final String title;
  final String body;
  final DateTime scheduledFor;

  const AlarmRingPage({
    super.key,
    required this.alarmId,
    required this.title,
    required this.body,
    required this.scheduledFor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AlarmRingController(
        alarmId: alarmId,
        title: title,
        body: body,
        scheduledFor: scheduledFor,
      ),
      tag: 'alarm_ring_$alarmId',
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.cordefundo,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.alarm,
                  color: Colors.white,
                  size: 90,
                ),

                const SizedBox(height: 24),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 48),

                Obx(
                  () => SizedBox(
                    width: 280,
                    height: 58,
                    child: BotaoPrimario(
                      texto: controller.loading.value
                          ? 'Aguarde...'
                          : 'Sim, já tomei',
                      onPressed: controller.confirmTaken,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 280,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: controller.confirmNotTaken,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Não tomei',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: controller.snooze,
                  child: const Text(
                    'Adiar 5 minutos',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}