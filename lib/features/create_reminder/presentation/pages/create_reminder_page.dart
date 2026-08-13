import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/primary_button.dart';
import 'package:tomora/features/create_reminder/presentation/controllers/create_reminder_controller.dart';
import 'package:tomora/features/create_reminder/presentation/widgets/reminder_text_field.dart';
import 'package:tomora/features/create_reminder/presentation/widgets/reminder_time_picker.dart';
import 'package:tomora/features/home/presentation/widgets/home_bottom_navigation.dart';

class CreateReminderPage extends GetView<CreateReminderController> {
  const CreateReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cordefundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 30, 32, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 28),

              ReminderTextField(
                label: 'Nome',
                hint: 'Digite o nome do medicamento',
                icon: Icons.link,
                controller: controller.nameController,
              ),

              const SizedBox(height: 20),

              ReminderTextField(
                label: 'Dosagem',
                hint: 'Insira a dosagem',
                icon: Icons.edit_outlined,
                controller: controller.dosageController,
              ),

              const SizedBox(height: 20),

              ReminderTextField(
                label: 'Descrição',
                hint: 'Insira a descrição (opcional)',
                icon: Icons.description_outlined,
                controller: controller.descController,
              ),

              const SizedBox(height: 12),

              Obx(
                () => ReminderTimePicker(
                  initialHour: controller.selectedHour.value,
                  initialMinute: controller.selectedMinute.value,
                  onHourChanged: controller.setHour,
                  onMinuteChanged: controller.setMinute,
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: SizedBox(
                  width: 320,
                  height: 60,
                  child: Obx(
                    () => BotaoPrimario(
                      texto: controller.loading.value
                          ? 'Criando...'
                          : 'Criar',
                      onPressed: controller.createReminder,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Novo Lembrete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}