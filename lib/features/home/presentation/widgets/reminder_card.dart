import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/features/home/data/models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final ReminderStatus status;
  final VoidCallback onTake;
  final VoidCallback onDelete;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.status,
    required this.onTake,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 23),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // imagem do medicamento

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                Text(
                  'Dosagem: ${reminder.dosage}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Horário: ${reminder.time}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (status != ReminderStatus.pending)
                  _buildStatus(),
              ],
            ),
          ),

          // Botões de ação: marcar como tomado e excluir
          Column(
            children: [
              if (status != ReminderStatus.taken)
                IconButton(
                  onPressed: onTake,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  tooltip: 'Marcar como tomado',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white24,
                  ),
                ),

              const SizedBox(height: 6),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                tooltip: 'Excluir lembrete',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case ReminderStatus.taken:
        return AppColors.verde;

      case ReminderStatus.missed:
        return Colors.redAccent;

      case ReminderStatus.pending:
        return Colors.deepPurple.shade200;
    }
  }

  Widget _buildStatus() {
    final text = status == ReminderStatus.taken
        ? 'Já tomou'
        : 'Não tomou';

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white54,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }
}