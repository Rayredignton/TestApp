// product_model.dart
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String thumbnail;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    required this.thumbnail,
    required this.description,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? '',
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      category: json["category"] ?? '',
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      thumbnail: json["thumbnail"] ?? '',
      description: json["description"] ?? '',
      images: List<String>.from(json["images"] ?? []),
    );
  }
}