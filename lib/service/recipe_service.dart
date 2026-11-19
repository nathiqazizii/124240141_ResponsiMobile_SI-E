import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/recipe.dart';

class RecipeService {
  static const String baseUrl = 'https://dummyjson.com/recipes';

  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> list = data['recipes'] ?? [];
      return list
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat resep: HTTP ${response.statusCode}');
    }
  }

  Future<Recipe> fetchRecipeDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail resep: HTTP ${response.statusCode}');
    }
  }
}
