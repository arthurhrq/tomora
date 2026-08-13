import 'package:get/get.dart';
import 'package:tomora/features/account_conection/presentation/pages/connection_code_page.dart';
import 'package:tomora/features/auth/presentation/controllers/login_controller.dart';
import 'package:tomora/features/auth/presentation/controllers/sign_controller.dart';
import 'package:tomora/features/auth/presentation/pages/login_page.dart';
import 'package:tomora/features/auth/presentation/pages/sign_page.dart';
import 'package:tomora/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
    ),
    GetPage(
      name: AppRoutes.sign,
      page: () => SignPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignController());
      }),
    ),
    GetPage(
      name: AppRoutes.screenMedicado,
      page: () => const ConnectionCodePage(),
    ),
  ];
}