import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/detail_controller.dart';
import '../../controller/favorite_controller.dart';
import '../../model/recipe.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  final DetailController _detailController = Get.find<DetailController>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  Widget _buildImageError() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[100],
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: 64,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(String imageUrl) {
    if (imageUrl.trim().isEmpty) {
      return _buildImageError();
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey[100],
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A859),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildImageError();
      },
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF00A859)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Resep'),
        backgroundColor: const Color(0xFF00A859),
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            final Recipe? recipe = _detailController.recipe;
            if (recipe == null) {
              return const SizedBox.shrink();
            }

            final isFav = _favoriteController.isFavorite(recipe.id);

            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.yellowAccent : Colors.white,
              ),
              tooltip: isFav ? 'Hapus dari favorite' : 'Tambah ke favorite',
              onPressed: () async {
                final added = await _favoriteController.toggleFavorite(recipe);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        added
                            ? 'Ditambahkan ke favorite'
                            : 'Dihapus dari favorite',
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (_detailController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A859),
            ),
          );
        }

        if (_detailController.errorMessage.isNotEmpty ||
            _detailController.recipe == null) {
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
                    _detailController.errorMessage.isNotEmpty
                        ? _detailController.errorMessage
                        : 'Data resep tidak ditemukan.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _detailController.fetchDetail,
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

        final Recipe recipe = _detailController.recipe!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderImage(recipe.image),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recipe.mealType.isNotEmpty
                          ? '${recipe.cuisine} • ${recipe.mealType.join(", ")}'
                          : recipe.cuisine,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildStatChip(
                          Icons.star,
                          '★ ${recipe.rating} (${recipe.reviewCount})',
                        ),
                        _buildStatChip(
                          Icons.speed,
                          recipe.difficulty,
                        ),
                        _buildStatChip(
                          Icons.timer_outlined,
                          'Persiapan ${recipe.prepTimeMinutes} mnt',
                        ),
                        _buildStatChip(
                          Icons.local_fire_department_outlined,
                          'Masak ${recipe.cookTimeMinutes} mnt',
                        ),
                        _buildStatChip(
                          Icons.people_outline,
                          '${recipe.servings} porsi',
                        ),
                        _buildStatChip(
                          Icons.bolt_outlined,
                          '${recipe.caloriesPerServing} kal/porsi',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Bahan-bahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.ingredients.map((ingredient) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF00A859),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Langkah Memasak',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(recipe.instructions.length, (index) {
                        final step = recipe.instructions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: const Color(0xFF00A859),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  step,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
