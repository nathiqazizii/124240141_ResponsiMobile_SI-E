import 'package:get/get.dart';
import '../model/recipe.dart';
import '../service/recipe_service.dart';

class RecipeController extends GetxController {
  final RecipeService _service = RecipeService();

  final RxList<Recipe> _recipes = <Recipe>[].obs;
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final list = await _service.fetchRecipes();
      _recipes.assignAll(list);
    } catch (e) {
      _errorMessage.value = 'Gagal memuat resep. Periksa koneksi internet Anda.';
    } finally {
      _isLoading.value = false;
    }
  }
}
