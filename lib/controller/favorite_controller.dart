import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../model/recipe.dart';

class FavoriteController extends GetxController {
  final Box<Recipe> _favBox = Hive.box<Recipe>('favorite_recipes');
  final RxList<Recipe> _favorites = <Recipe>[].obs;

  List<Recipe> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    final List<Recipe> list = [];
    for (final key in _favBox.keys) {
      final item = _favBox.get(key);
      if (item != null) {
        list.add(item);
      }
    }
    _favorites.assignAll(list);
  }

  bool isFavorite(int id) {
    return _favorites.any((r) => r.id == id);
  }

  Future<bool> toggleFavorite(Recipe recipe) async {
    if (isFavorite(recipe.id)) {
      await _favBox.delete(recipe.id);
      _favorites.removeWhere((r) => r.id == recipe.id);
      return false;
    } else {
      final copy = recipe.copy();
      await _favBox.put(recipe.id, copy);
      _favorites.add(copy);
      return true;
    }
  }

  Future<void> removeFavorite(int id) async {
    await _favBox.delete(id);
    _favorites.removeWhere((r) => r.id == id);
  }
}
