import 'package:get_storage/get_storage.dart';

class TokenStorage {
  // Cria a instância do GetStorage
  final _box = GetStorage();

  // Chave que usamos para guardar o token
  static const _tokenKey = 'auth_token';

  // Salva o token no celular
  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  // Lê o token salvo
  String? getToken() {
    return _box.read(_tokenKey);
  }

  // Apaga o token (usado no logout)
  Future<void> clearToken() async {
    await _box.remove(_tokenKey);
  }

  // Verifica se existe token salvo
  // Por que não utilizar o .hasData() do GetStorage? 
  // Porque ele verifica se existe algum dado, mas não necessariamente o token. 
  // Então, é melhor verificar se o token específico existe.
  bool get hasToken => getToken() != null;
}