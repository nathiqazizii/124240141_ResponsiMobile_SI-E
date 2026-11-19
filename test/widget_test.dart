import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:responsi/controller/auth_controller.dart';
import 'package:responsi/controller/favorite_controller.dart';
import 'package:responsi/model/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('responsi_recipe_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeAdapter());
    }
    await Hive.openBox<Recipe>('favorite_recipes');
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    Get.reset();
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await Hive.box<Recipe>('favorite_recipes').clear();
    Get.put<FavoriteController>(FavoriteController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  });

  test('Recipe.fromJson parses dummyjson recipe properly', () {
    final json = {
      'id': 1,
      'name': 'Classic Margherita Pizza',
      'ingredients': ['Pizza dough', 'Tomato sauce', 'Fresh mozzarella cheese'],
      'instructions': ['Preheat the oven.', 'Roll out dough.'],
      'prepTimeMinutes': 20,
      'cookTimeMinutes': 15,
      'servings': 4,
      'difficulty': 'Easy',
      'cuisine': 'Italian',
      'caloriesPerServing': 300,
      'image': 'https://cdn.dummyjson.com/recipe-images/1.webp',
      'rating': 4.6,
      'reviewCount': 98,
      'mealType': ['Dinner'],
    };

    final recipe = Recipe.fromJson(json);
    expect(recipe.id, 1);
    expect(recipe.name, 'Classic Margherita Pizza');
    expect(recipe.cuisine, 'Italian');
    expect(recipe.difficulty, 'Easy');
    expect(recipe.ingredients.length, 3);
    expect(recipe.instructions.length, 2);
    expect(recipe.rating, 4.6);
  });

  test('AuthController validates username nathiq and password 141', () async {
    final auth = Get.find<AuthController>();

    expect(await auth.login('', ''), isNotNull);
    expect(await auth.login('wrong', '141'), isNotNull);
    expect(await auth.login('nathiq', 'wrong'), isNotNull);
    expect(await auth.login('nathiq', '141'), isNull);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.currentUsername, 'nathiq');

    await auth.logout();
    expect(auth.isLoggedIn, isFalse);
    expect(auth.currentUsername, '');
  });

  test('FavoriteController toggles and saves recipes to Hive', () async {
    final fav = Get.find<FavoriteController>();

    final recipe = Recipe(
      id: 1,
      name: 'Classic Margherita Pizza',
      ingredients: ['Pizza dough'],
      instructions: ['Bake'],
      prepTimeMinutes: 20,
      cookTimeMinutes: 15,
      servings: 4,
      difficulty: 'Easy',
      cuisine: 'Italian',
      caloriesPerServing: 300,
      image: 'https://cdn.dummyjson.com/recipe-images/1.webp',
      rating: 4.6,
      reviewCount: 98,
      mealType: ['Dinner'],
    );

    expect(fav.isFavorite(1), isFalse);
    expect(await fav.toggleFavorite(recipe), isTrue);
    expect(fav.isFavorite(1), isTrue);
    expect(fav.favorites.length, 1);

    expect(await fav.toggleFavorite(recipe), isFalse);
    expect(fav.isFavorite(1), isFalse);
    expect(fav.favorites.isEmpty, isTrue);

    await fav.toggleFavorite(recipe);
    expect(fav.isFavorite(1), isTrue);

    await fav.removeFavorite(1);
    expect(fav.isFavorite(1), isFalse);
    expect(fav.favorites.isEmpty, isTrue);
  });
}
