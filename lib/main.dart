import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tomora/core/network/api_client.dart';
import 'package:tomora/features/account_conection/data/repository/connection_repository.dart';
import 'package:tomora/features/auth/data/services/auth_service.dart';
import 'package:tomora/features/auth/presentation/controllers/user_controller.dart';
import 'package:tomora/routes/app_pages.dart';
import 'package:tomora/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // IMPORTANTE: sem "/rest/v1/" no final — o client já adiciona isso sozinho.
    url: 'https://koadenowercbqwgwuuxq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtvYWRlbm93ZXJjYnF3Z3d1dXhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU5MzcxNzQsImV4cCI6MjEwMTUxMzE3NH0.jvNQhClgh6VkzGpjyRiKei2cAQG2Er5W0NTL3MWetqQ',
  );

  // Inicializa o GetStorage
  await GetStorage.init();

  // Registra as dependências
  Get.put(ApiClient());
  Get.put(AuthService());
  Get.put(UserController(), permanent: true);
  Get.put(ConnectionRepository(Supabase.instance.client), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tomora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}