// lib/features/cart/data/cart_model.dart
import 'package:hive/hive.dart';
import 'package:pawltest/features/feed/data/product_model.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String thumbnail;

  @HiveField(4)
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.quantity = 1,
  });

  factory CartItem.fromProduct(ProductModel product) {
    return CartItem(
      id: product.id,
      title: product.title,
      price: product.price,
      thumbnail: product.thumbnail,
    );
  }

  double get totalPrice => price * quantity;
}