// lib/core/locator.dart
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pawltest/core/api_client.dart';
import 'package:pawltest/core/local_db.dart';
import 'package:pawltest/features/cart/data/cart_model.dart';
import 'package:pawltest/features/cart/data/cart_repo.dart';
import 'package:pawltest/features/feed/data/product_repo.dart';
import 'package:pawltest/features/feed/data/product_model.dart';
import 'package:path_provider/path_provider.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Initialize Hive
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  
  // Register adapters
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartItemAdapter());
  
  // Open boxes
  final productBox = await Hive.openBox<ProductModel>('products');
  final cartBox = await Hive.openBox<CartItem>('cart');
  
  // Register dependencies
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => LocalDb());
  locator.registerLazySingleton(() => ProductRepo());
  locator.registerLazySingleton(() => CartRepo(cartBox)); // ✅ Register CartRepo
}