import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/recipe_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/recipe_grid_card.dart';

class RecipeListPage extends StatelessWidget {
  RecipeListPage({super.key});

  final RecipeController _recipeController = Get.find<RecipeController>();
  final AuthController _authController = Get.find<AuthController>();

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _authController.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resep Masakan'),
        backgroundColor: const Color(0xFF00A859),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorite',
            onPressed: () {
              Get.toNamed(AppRoutes.favorite);
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (_recipeController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A859),
            ),
          );
        }

        if (_recipeController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _recipeController.errorMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _recipeController.fetchRecipes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A859),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final recipes = _recipeController.recipes;

        return RefreshIndicator(
          color: const Color(0xFF00A859),
          onRefresh: _recipeController.fetchRecipes,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 600 ? 4 : 3;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: recipes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeGridCard(
                    recipe: recipe,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.detail,
                        arguments: recipe,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
