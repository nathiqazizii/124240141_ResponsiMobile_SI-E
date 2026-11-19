import 'package:get/get.dart';
import '../model/recipe.dart';
import '../service/recipe_service.dart';

class DetailController extends GetxController {
  final RecipeService _service = RecipeService();

  late final int recipeId;

  final Rxn<Recipe> _recipe = Rxn<Recipe>();
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;

  Recipe? get recipe => _recipe.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Recipe) {
      recipeId = args.id;
      _recipe.value = args;
      _isLoading.value = false;
      fetchDetail();
    } else if (args is int) {
      recipeId = args;
      fetchDetail();
    } else if (args is Map && args['id'] != null) {
      recipeId = args['id'] as int;
      fetchDetail();
    } else {
      recipeId = 1;
      fetchDetail();
    }
  }

  Future<void> fetchDetail() async {
    try {
      if (_recipe.value == null) {
        _isLoading.value = true;
      }
      _errorMessage.value = '';
      final data = await _service.fetchRecipeDetail(recipeId);
      _recipe.value = data;
    } catch (e) {
      if (_recipe.value == null) {
        _errorMessage.value = 'Gagal memuat detail resep.';
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
