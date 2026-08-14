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
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(
        26,
        22,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.medication_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Dosagem: ${reminder.dosage}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Horário: ${reminder.time}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                if (status != ReminderStatus.pending)
                  _buildStatus(),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            children: [
              if (status != ReminderStatus.taken)
                IconButton(
                  onPressed: onTake,
                  icon: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                  tooltip: 'Marcar como tomado',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.18),
                    padding: const EdgeInsets.all(10),
                  ),
                ),

              if (status != ReminderStatus.taken)
                const SizedBox(height: 5),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 21,
                ),
                tooltip: 'Excluir lembrete',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.18),
                  padding: const EdgeInsets.all(10),
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
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white38,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}