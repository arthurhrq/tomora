import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tomora/features/home/data/models/history_model.dart';
import 'package:tomora/features/home/data/models/reminder_model.dart';

class ReminderRepository {
  final SupabaseClient supabase;

  ReminderRepository(this.supabase);

  /// Busca os lembretes ativos de todos os userIds informados
  /// (medicado + auxiliar, quando conectados).
  Future<List<ReminderModel>> getRemindersForUsers(
    List<int> userIds,
  ) async {
    final response = await supabase
        .from('Reminder')
        .select()
        .inFilter('userId', userIds)
        .eq('active', true)
        .order('time');

    return (response as List)
        .map(
          (json) => ReminderModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Busca o histórico (tomado / não tomado) referente ao dia de hoje,
  /// para todos os userIds informados.
  Future<List<HistoryModel>> getTodayHistory(
    List<int> userIds,
  ) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await supabase
        .from('History')
        .select()
        .inFilter('userId', userIds)
        .gte('scheduledFor', startOfDay.toIso8601String())
        .lt('scheduledFor', endOfDay.toIso8601String());

    return (response as List)
        .map(
          (json) => HistoryModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Cria um novo lembrete para o usuário informado.
  /// [time] deve estar no formato "HH:mm".
  Future<void> createReminder({
    required int userId,
    required String name,
    required String dosage,
    String? desc,
    required String time,
    bool callAlexa = false,
  }) async {
    final now = DateTime.now().toIso8601String();

    await supabase.from('Reminder').insert({
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'desc': desc,
      'time': time,
      'active': true,
      'callAlexa': callAlexa,
      'createdAt': now,
      'updatedAt': now,
    });
  }
}