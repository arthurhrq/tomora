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

  /// Cria um novo lembrete para o usuário informado e retorna o registro
  /// criado (com o id gerado pelo banco), necessário para agendar o alarme.
  /// [time] deve estar no formato "HH:mm".
  Future<ReminderModel> createReminder({
    required int userId,
    required String name,
    required String dosage,
    String? desc,
    required String time,
    bool callAlexa = false,
  }) async {
    final now = DateTime.now().toIso8601String();

    final response = await supabase
        .from('Reminder')
        .insert({
          'userId': userId,
          'name': name,
          'dosage': dosage,
          'desc': desc,
          'time': time,
          'active': true,
          'callAlexa': callAlexa,
          'createdAt': now,
          'updatedAt': now,
        })
        .select()
        .single();

    return ReminderModel.fromJson(response);
  }

  /// "Exclui" o lembrete. Na prática desativa (active = false) em vez de
  /// apagar de verdade, pra não quebrar o histórico (History) que já
  /// referencia esse reminderId.
  Future<void> deleteReminder(int reminderId) async {
    await supabase
        .from('Reminder')
        .update({'active': false})
        .eq('id', reminderId);
  }

  /// Registra no histórico se o lembrete foi tomado ou não, para o
  /// horário agendado informado.
  Future<void> recordHistory({
    required int userId,
    required int reminderId,
    required DateTime scheduledFor,
    required bool taken,
  }) async {
    await supabase.from('History').insert({
      'userId': userId,
      'reminderId': reminderId,
      'scheduledFor': scheduledFor.toIso8601String(),
      'takenAt': taken ? DateTime.now().toIso8601String() : null,
      'taken': taken,
    });
  }
}