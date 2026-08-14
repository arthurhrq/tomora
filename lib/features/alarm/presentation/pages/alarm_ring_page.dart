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
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 32,
            ),
            child: Column(
              children: [
                const Spacer(flex: 2),

                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.18),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.alarm,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 330,
                  ),
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: BotaoPrimario(
                      texto: controller.loading.value
                          ? 'Aguarde...'
                          : 'Sim, já tomei',
                      onPressed: controller.confirmTaken,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(
                    onPressed: controller.confirmNotTaken,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Não tomei',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: controller.snooze,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'Adiar 5 minutos',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}