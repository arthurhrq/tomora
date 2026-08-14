import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/features/home/data/models/reminder_model.dart';
import 'package:tomora/features/home/presentation/controllers/home_controller.dart';
import 'package:tomora/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:tomora/features/home/presentation/widgets/reminder_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cordefundo,

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              _buildHeader(),

              Expanded(
                child: _buildReminders(context),
              ),
            ],
          );
        }),
      ),

      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        32,
        30,
        22,
        20,
      ),
      child: Row(
        children: [
          Text(
            'Diário',
            style: TextStyle(
              color: AppColors.verde,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.verde,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(width: 10),

          IconButton(
            onPressed: controller.loadHome,
            icon: Icon(
              Icons.refresh,
              color: AppColors.verde,
            ),
            tooltip: 'Atualizar',
          ),
        ],
      ),
    );
  }

  Widget _buildReminders(BuildContext context) {
    if (controller.reminders.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum lembrete cadastrado.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      itemCount: controller.reminders.length,
      itemBuilder: (context, index) {
        final reminder = controller.reminders[index];

        final status = controller.getReminderStatus(
          reminder,
        );

        return ReminderCard(
          reminder: reminder,
          status: status,
          onTake: () => controller.markAsTaken(reminder),
          onDelete: () => _confirmDelete(context, reminder),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ReminderModel reminder,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cordefundo,
        title: const Text(
          'Excluir lembrete',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Tem certeza que deseja excluir "${reminder.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      controller.deleteReminder(reminder);
    }
  }
}