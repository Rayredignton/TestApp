// lib/features/feed/data/product_repo.dart
import 'package:pawltest/core/api_client.dart';
import 'package:pawltest/core/local_db.dart';
import 'package:pawltest/core/locator.dart';
import 'package:pawltest/features/feed/data/product_model.dart';

class ProductRepo {
  final _api = locator<ApiClient>();
  final _db = locator<LocalDb>();

  Future<List<ProductModel>> getProducts(int skip) async {
    try {
      final res = await _api.get('/products', params: {
        'limit': 10,
        'skip': skip,
      });
      
      final list = res.data['products'] as List;
      final products = list.map((e) => ProductModel.fromJson(e)).toList();
      
      for (var p in products) {
        await _db.saveProduct(p);
      }
      
      return products;
    } catch (_) {
      return _db.getProducts(skip, 10);
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category, int skip) async {
    try {
      final res = await _api.get('/products/category/$category', params: {
        'limit': 10,
        'skip': skip,
      });
      
      final list = res.data['products'] as List;
      final products = list.map((e) => ProductModel.fromJson(e)).toList();
      
      for (var p in products) {
        await _db.saveProduct(p);
      }
      
      return products;
    } catch (_) {
      return _db.getProductsByCategory(category, skip, 10);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final res = await _api.get('/products/categories');
      return List<String>.from(res.data);
    } catch (_) {
      final products = _db.getAllProducts();
      return products.map((p) => p.category).toSet().toList();
    }
  }
}