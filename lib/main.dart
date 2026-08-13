import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tomora/core/network/api_client.dart';
import 'package:tomora/features/auth/data/services/auth_service.dart';
import 'package:tomora/routes/app_pages.dart';
import 'package:tomora/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o GetStorage
  await GetStorage.init();

  // Registra as dependências
  Get.put(ApiClient());
  Get.put(AuthService());
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