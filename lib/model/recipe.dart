import 'package:hive/hive.dart';

class Recipe extends HiveObject {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;
  final String image;
  final double rating;
  final int reviewCount;
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });

  Recipe copy() {
    return Recipe(
      id: id,
      name: name,
      ingredients: List<String>.from(ingredients),
      instructions: List<String>.from(instructions),
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      difficulty: difficulty,
      cuisine: cuisine,
      caloriesPerServing: caloriesPerServing,
      image: image,
      rating: rating,
      reviewCount: reviewCount,
      mealType: List<String>.from(mealType),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? '').toString(),
      ingredients: (json['ingredients'] as List? ?? []).map((e) => e.toString()).toList(),
      instructions: (json['instructions'] as List? ?? []).map((e) => e.toString()).toList(),
      prepTimeMinutes: json['prepTimeMinutes'] is int
          ? json['prepTimeMinutes'] as int
          : int.tryParse('${json['prepTimeMinutes']}') ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] is int
          ? json['cookTimeMinutes'] as int
          : int.tryParse('${json['cookTimeMinutes']}') ?? 0,
      servings: json['servings'] is int
          ? json['servings'] as int
          : int.tryParse('${json['servings']}') ?? 0,
      difficulty: (json['difficulty'] ?? '').toString(),
      cuisine: (json['cuisine'] ?? '').toString(),
      caloriesPerServing: json['caloriesPerServing'] is int
          ? json['caloriesPerServing'] as int
          : int.tryParse('${json['caloriesPerServing']}') ?? 0,
      image: (json['image'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] is int
          ? json['reviewCount'] as int
          : int.tryParse('${json['reviewCount']}') ?? 0,
      mealType: (json['mealType'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as int,
      name: fields[1] as String,
      ingredients: (fields[2] as List).cast<String>(),
      instructions: (fields[3] as List).cast<String>(),
      prepTimeMinutes: fields[4] as int,
      cookTimeMinutes: fields[5] as int,
      servings: fields[6] as int,
      difficulty: fields[7] as String,
      cuisine: fields[8] as String,
      caloriesPerServing: fields[9] as int,
      image: fields[10] as String,
      rating: (fields[11] as num).toDouble(),
      reviewCount: fields[12] as int,
      mealType: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.instructions)
      ..writeByte(4)
      ..write(obj.prepTimeMinutes)
      ..writeByte(5)
      ..write(obj.cookTimeMinutes)
      ..writeByte(6)
      ..write(obj.servings)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.cuisine)
      ..writeByte(9)
      ..write(obj.caloriesPerServing)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.rating)
      ..writeByte(12)
      ..write(obj.reviewCount)
      ..writeByte(13)
      ..write(obj.mealType);
  }
}
