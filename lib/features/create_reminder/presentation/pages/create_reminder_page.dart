import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/custom_text_field.dart';
import 'package:tomora/core/widgets/primary_button.dart';
import 'package:tomora/features/create_reminder/presentation/controllers/create_reminder_controller.dart';
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

              SizedBox(
                width: double.infinity,
                child: CampoPersonalizado(
                  title: 'Nome',
                  hintText: 'Digite o nome do medicamento',
                  controller: controller.nameController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Icon(Icons.link, color: AppColors.branco),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: CampoPersonalizado(
                  title: 'Dosagem',
                  hintText: 'Insira a dosagem',
                  controller: controller.dosageController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Icon(Icons.edit_outlined, color: AppColors.branco),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: CampoPersonalizado(
                  title: 'Descrição',
                  hintText: 'Insira a descrição (opcional)',
                  controller: controller.descController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.branco,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Obx(
                () => ReminderTimePicker(
                  initialHour: controller.selectedHour.value,
                  initialMinute: controller.selectedMinute.value,
                  onHourChanged: controller.setHour,
                  onMinuteChanged: controller.setMinute,
                ),
              ),

              const SizedBox(height: 30),

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
            color: AppColors.verde,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins'
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Container(
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.verde,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}