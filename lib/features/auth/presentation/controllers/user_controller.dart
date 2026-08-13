import 'package:get/get.dart';
import 'package:tomora/features/auth/data/model/user_model.dart';

/// Guarda o usuário atualmente logado em memória, para que qualquer
/// controller do app (Home, etc.) possa acessar via Get.find<UserController>().
///
/// IMPORTANTE: precisa ser registrado ANTES da tela de login/home, e como
/// `permanent: true`, para não ser destruído ao trocar de rota.
/// Ex. no main.dart ou InitialBinding:
///   Get.put(UserController(), permanent: true);
class UserController extends GetxController {
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  /// Usuário logado. Lança exceção se acessado sem login feito.
  UserModel get user {
    final value = _user.value;
    if (value == null) {
      throw Exception('Nenhum usuário logado.');
    }
    return value;
  }

  /// Versão segura, para telas que precisam checar sem quebrar (ex: splash).
  UserModel? get userOrNull => _user.value;

  bool get isLoggedIn => _user.value != null;

  void setUser(UserModel user) {
    _user.value = user;
  }

  void clearUser() {
    _user.value = null;
  }
}