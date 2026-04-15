import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/bindings.dart';
import 'app/theme/app_theme.dart';
import 'app/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = Get.put(ThemeController());
    Firebase.initializeApp();
    return Obx(() => GetMaterialApp(
          title: 'Plastic Business',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: tc.mode,
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.pages,
          initialBinding: AuthBinding(),
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 280),
        ));
  }
}
