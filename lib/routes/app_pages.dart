import 'package:get/get.dart';
import 'package:tomora/features/account_conection/data/repository/connection_repository.dart';
import 'package:tomora/features/account_conection/presentation/controllers/connect_account_controller.dart';
import 'package:tomora/features/account_conection/presentation/pages/connect_account_page.dart';
import 'package:tomora/features/account_conection/presentation/pages/connection_code_page.dart';
import 'package:tomora/features/auth/presentation/controllers/login_controller.dart';
import 'package:tomora/features/auth/presentation/controllers/sign_controller.dart';
import 'package:tomora/features/auth/presentation/pages/login_page.dart';
import 'package:tomora/features/auth/presentation/pages/sign_page.dart';
import 'package:tomora/features/create_reminder/presentation/controllers/create_reminder_controller.dart';
import 'package:tomora/features/create_reminder/presentation/pages/create_reminder_page.dart';
import 'package:tomora/features/faq/presentation/pages/faq_page.dart';
import 'package:tomora/features/home/presentation/controllers/home_controller.dart';
import 'package:tomora/features/home/presentation/pages/home_page.dart';
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
    GetPage(
      name: AppRoutes.screenAuxiliar,
      page: () => const ConnectAccountPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(
          () => ConnectAccountController(Get.find<ConnectionRepository>()),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      // ReminderRepository e AlarmService já são globais (main.dart)
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController(Get.find()));
      }),
    ),
    GetPage(
      name: AppRoutes.create,
      page: () => const CreateReminderPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CreateReminderController(Get.find()));
      }),
    ),
    GetPage(
      // Tela 100% decorativa: sem controller/repository, então sem binding.
      name: AppRoutes.faq,
      page: () => const FaqPage(),
    ),
  ];
}