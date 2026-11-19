import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controller/auth_controller.dart';
import 'controller/favorite_controller.dart';
import 'model/recipe.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());

  await Hive.openBox<Recipe>('favorite_recipes');

  Get.put<FavoriteController>(FavoriteController(), permanent: true);
  final authController = Get.put<AuthController>(AuthController(), permanent: true);
  await authController.checkSession();

  runApp(
    MainApp(
      initialRoute: authController.isLoggedIn ? AppRoutes.home : AppRoutes.login,
    ),
  );
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Resep Masakan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A859),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
