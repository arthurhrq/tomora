import 'package:get/get.dart';
import 'package:tomora/core/network/api_endpoints.dart';
import 'package:tomora/core/storage/token_storage.dart';

class ApiClient extends GetConnect {
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void onInit() {
    // Define a URL base de todas as requisições
    httpClient.baseUrl = ApiEndpoints.baseUrl;

    // Tempo máximo de espera
    httpClient.timeout = const Duration(seconds: 20);

    // Interceptor: adiciona o token automaticamente em TODAS as requisições
    httpClient.addRequestModifier<dynamic>((request) {
      final token = _tokenStorage.getToken();

      if (token != null) {
        // Formato exigido pela sua API: "Bearer <token>"
        request.headers['Authorization'] = 'Bearer $token';
      }

      return request;
    });

    super.onInit();
  }
}