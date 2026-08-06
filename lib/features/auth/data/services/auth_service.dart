import 'package:get/get.dart';
import 'package:tomora/core/network/api_client.dart';
import 'package:tomora/core/network/api_endpoints.dart';
import 'package:tomora/core/storage/token_storage.dart';
import 'package:tomora/features/auth/data/model/user_model.dart';

class AuthService extends GetxService {
  final ApiClient _api = Get.find<ApiClient>();
  final TokenStorage _tokenStorage = TokenStorage();

  // ====================== LOGIN ======================
  // 1. Chama /api/login
  // 2. Recebe o token
  // 3. Salva o token
  Future<void> login({
  required String email,
  required String password,
}) async {
  final response = await _api.post(
    ApiEndpoints.login,
    {
      'email': email,
      'password': password,
    },
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
  print('Body type: ${response.body.runtimeType}');

  if (response.status.hasError) {
    final errorMsg = response.body is Map
        ? (response.body['erro'] ?? response.body['error'] ?? 'Erro ao fazer login')
        : response.statusText ?? 'Erro ao fazer login';
    throw Exception(errorMsg);
  }

  // Trata o body com segurança
  final body = response.body;

  String? token;

  if (body is Map) {
    token = body['token'];
  } else if (body is String) {
    // Caso raro, mas pode acontecer
    throw Exception('Resposta inesperada da API: $body');
  }

  if (token == null) {
    throw Exception('Token não recebido da API');
  }

  await _tokenStorage.saveToken(token);
}

  // ====================== BUSCAR USUÁRIO LOGADO ======================
  // Chama /api/auth/me (já com o token no header automaticamente)
  Future<UserModel> getMe() async {
  final response = await _api.get(ApiEndpoints.me);

  print('Status /me: ${response.statusCode}');
  print('Body /me: ${response.body}');

  if (response.status.hasError) {
    final errorMsg = response.body is Map
        ? (response.body['erro'] ?? response.body['error'] ?? 'Erro ao buscar usuário')
        : response.statusText ?? 'Erro ao buscar usuário';
    throw Exception(errorMsg);
  }

  final body = response.body;

  if (body is! Map) {
    throw Exception('Resposta inválida do /me');
  }

  final userData = body['user'];

  if (userData == null || userData is! Map) {
    throw Exception('Dados do usuário não encontrados');
  }

  return UserModel.fromJson(Map<String, dynamic>.from(userData));
}

  // ====================== LOGOUT ======================
  Future<void> logout() async {
    await _tokenStorage.clearToken();
  }
}