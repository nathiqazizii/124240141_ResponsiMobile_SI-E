import 'package:get/get.dart';
import '../controller/detail_controller.dart';
import '../controller/recipe_controller.dart';
import '../view/pages/detail_page.dart';
import '../view/pages/favorite_page.dart';
import '../view/pages/login_page.dart';
import '../view/pages/recipe_list_page.dart';
import 'app_routes.dart';

class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeController>(() => RecipeController());
  }
}

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController());
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => RecipeListPage(),
      binding: RecipeBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => DetailPage(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: AppRoutes.favorite,
      page: () => FavoritePage(),
    ),
  ];
}
