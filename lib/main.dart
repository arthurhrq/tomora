import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tomora/core/network/api_client.dart';
import 'package:tomora/core/services/alarm_service.dart';
import 'package:tomora/core/services/notification_service.dart';
import 'package:tomora/core/storage/token_storage.dart';
import 'package:tomora/features/account_conection/data/repository/connection_repository.dart';
import 'package:tomora/features/auth/data/services/auth_service.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/features/home/data/repository/reminder_repository.dart';
import 'package:tomora/routes/app_pages.dart';
import 'package:tomora/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // IMPORTANTE: sem "/rest/v1/" no final — o client já adiciona isso sozinho.
    url: 'https://koadenowercbqwgwuuxq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtvYWRlbm93ZXJjYnF3Z3d1dXhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU5MzcxNzQsImV4cCI6MjEwMTUxMzE3NH0.jvNQhClgh6VkzGpjyRiKei2cAQG2Er5W0NTL3MWetqQ',
  );

  // Inicializa o GetStorage (é aqui que o token de login fica salvo em
  // disco, entre uma abertura do app e outra).
  await GetStorage.init();

  // Registra as dependências globais (permanentes)
  Get.put(ApiClient());
  Get.put(AuthService());
  Get.put(UserController(), permanent: true);
  Get.put(ConnectionRepository(Supabase.instance.client), permanent: true);
  Get.put(ReminderRepository(Supabase.instance.client), permanent: true);

  // Inicializa o serviço de notificações de status bar
  // (flutter_local_notifications), usado pelo AlarmService quando um
  // alarme começa a tocar.
  final notificationService = await NotificationService().init();
  Get.put(notificationService, permanent: true);

  // Inicializa o serviço de alarme (Alarm.init() + listener de "tocando")
  final alarmService = AlarmService();
  await alarmService.init();
  Get.put(alarmService, permanent: true);

  // Se já existe um token salvo (GetStorage persiste em disco, então
  // sobrevive a fechar/reabrir o app), tenta restaurar a sessão sem
  // pedir login de novo. Se o token estiver expirado/inválido, cai pro
  // login normalmente.
  final initialRoute = await _resolveInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

/// Decide pra qual tela o app deve abrir, tentando restaurar a sessão
/// salva localmente (token em GetStorage). Mesma lógica de decisão de
/// destino usada no LoginController, só que rodando automaticamente no
/// boot do app em vez de precisar o usuário logar de novo toda vez.
Future<String> _resolveInitialRoute() async {
  final tokenStorage = TokenStorage();

  if (!tokenStorage.hasToken) {
    return AppRoutes.login;
  }

  try {
    final authService = Get.find<AuthService>();
    final user = await authService.getMe();

    Get.find<UserController>().setUser(user);

    if (user.role == 'MEDICADO') {
      return user.caregiverId != null
          ? AppRoutes.home
          : AppRoutes.screenMedicado;
    }

    if (user.role == 'AUXILIAR') {
      final connectionRepository = Get.find<ConnectionRepository>();
      final alreadyLinked = await connectionRepository
          .hasAuxiliarLinkedMedicados(int.parse(user.id));

      return alreadyLinked ? AppRoutes.home : AppRoutes.screenAuxiliar;
    }

    return AppRoutes.login;
  } catch (e) {
    // Token expirado, revogado, ou erro de rede na 1ª checagem: limpa o
    // token salvo e manda pro login normalmente, sem travar o app.
    await tokenStorage.clearToken();
    return AppRoutes.login;
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  // Valor padrão = tela de login, pra continuar dando pra instanciar
  // `MyApp()` sem argumento (ex: em testes de widget) sem quebrar.
  // Em produção, main() sempre passa o initialRoute já resolvido.
  const MyApp({super.key, this.initialRoute = AppRoutes.login});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tomora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}