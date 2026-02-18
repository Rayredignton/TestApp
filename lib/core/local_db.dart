// lib/core/local_db.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pawltest/features/cart/data/cart_model.dart';
import 'package:pawltest/features/feed/data/product_model.dart';

class LocalDb {
  static const String productBox = "products";
  static const String cartBox = "cart";
    static bool _adaptersRegistered = false;

   Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters only once
    if (!_adaptersRegistered) {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ProductModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(CartItemAdapter());
      }
      _adaptersRegistered = true;
    }

    await Hive.openBox<ProductModel>(productBox);
    await Hive.openBox<CartItem>(cartBox);
    
   
  }


  // Products
  Future<void> saveProduct(ProductModel product) async {
    final box = Hive.box<ProductModel>(productBox);
    await box.put(product.id, product);
  }

  List<ProductModel> getProducts(int skip, int limit) {
    final box = Hive.box<ProductModel>(productBox);
    final all = box.values.toList();
    
    if (all.isEmpty) return [];
    
    all.sort((a, b) => a.id.compareTo(b.id));
    
    final start = skip;
    final end = (skip + limit) > all.length ? all.length : skip + limit;
    
    if (start >= all.length) return [];
    
    return all.sublist(start, end);
  }

  List<ProductModel> getProductsByCategory(String category, int skip, int limit) {
    final box = Hive.box<ProductModel>(productBox);
    final filtered = box.values.where((p) => p.category == category).toList();
    
    if (filtered.isEmpty) return [];
    
    filtered.sort((a, b) => a.id.compareTo(b.id));
    
    final start = skip;
    final end = (skip + limit) > filtered.length ? filtered.length : skip + limit;
    
    if (start >= filtered.length) return [];
    
    return filtered.sublist(start, end);
  }

  List<ProductModel> getAllProducts() {
    final box = Hive.box<ProductModel>(productBox);
    return box.values.toList();
  }

  // Cart
  Future<void> addToCart(CartItem item) async {
    final box = Hive.box<CartItem>(cartBox);
    await box.add(item);
  }

  Future<void> removeFromCart(int productId) async {
    final box = Hive.box<CartItem>(cartBox);
    final item = box.values.firstWhere(
      (i) => i.id == productId,
      orElse: () => null as CartItem,
    );
    if (item != null) await item.delete();
  }

  List<CartItem> getCartItems() {
    final box = Hive.box<CartItem>(cartBox);
    return box.values.toList();
  }

  Future<void> clearCart() async {
    final box = Hive.box<CartItem>(cartBox);
    await box.clear();
  }
}