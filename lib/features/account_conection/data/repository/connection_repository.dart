import 'package:supabase_flutter/supabase_flutter.dart';

class ConnectionRepository {
  final SupabaseClient supabase;

  ConnectionRepository(this.supabase);

  /// Verifica se o auxiliar já tem pelo menos um medicado vinculado
  /// (ou seja, se já existe algum User com role MEDICADO cujo
  /// caregiverId aponta pra esse auxiliar).
  Future<bool> hasAuxiliarLinkedMedicados(int auxiliarId) async {
    final response = await supabase
        .from('User')
        .select('id')
        .eq('caregiverId', auxiliarId)
        .eq('role', 'MEDICADO')
        .limit(1);

    return (response as List).isNotEmpty;
  }

  /// Vincula a conta do auxiliar à conta do medicado dono do [medicadoId]
  /// (o "código" que o medicado mostra na tela dele é o próprio id).
  /// Retorna true se encontrou e vinculou, false se o código não existe
  /// ou não pertence a um medicado.
  Future<bool> linkAccounts({
    required int auxiliarId,
    required int medicadoId,
  }) async {
    final response = await supabase
        .from('User')
        .update({'caregiverId': auxiliarId})
        .eq('id', medicadoId)
        .eq('role', 'MEDICADO')
        .select();

    return (response as List).isNotEmpty;
  }
}