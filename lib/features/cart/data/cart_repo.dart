// lib/features/cart/data/cart_repo.dart
import 'package:hive/hive.dart';
import 'package:pawltest/features/cart/data/cart_model.dart';

class CartRepo {
  final Box<CartItem> _box;

  CartRepo(this._box);

  Future<void> addItem(CartItem item) async {
    try {
      // Check if item already exists
      CartItem? existing;
      for (var cartItem in _box.values) {
        if (cartItem.id == item.id) {
          existing = cartItem;
          break;
        }
      }

      if (existing != null) {
        // Update quantity
        existing.quantity++;
        await existing.save();
   
      } else {
        // Add new item
        await _box.add(item);
    
      }
    } catch (e) {
      print('❌ Cart Error: $e');
    }
  }

  Future<void> removeItem(int productId) async {
    try {
      // Find item by id
      CartItem? itemToRemove;
      for (var item in _box.values) {
        if (item.id == productId) {
          itemToRemove = item;
          break;
        }
      }
      
      if (itemToRemove != null) {
        await itemToRemove.delete();

      }
    } catch (e) {
      print(' Cart Error: $e');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeItem(productId);
        return;
      }

      // Find item by id
      CartItem? item;
      for (var cartItem in _box.values) {
        if (cartItem.id == productId) {
          item = cartItem;
          break;
        }
      }
      
      if (item != null) {
        item.quantity = quantity;
        await item.save();
      
      }
    } catch (e) {
      print(' Error: $e');
    }
  }

  List<CartItem> getItems() {
    try {
      return _box.values.toList();
    } catch (e) {
      print(' Cart Error: $e');
      return [];
    }
  }

  int getTotalItems() {
    try {
      int total = 0;
      for (var item in _box.values) {
        total += item.quantity;
      }
      return total;
    } catch (e) {
      print(' Cart Error: $e');
      return 0;
    }
  }

  double getTotalPrice() {
    try {
      double total = 0;
      for (var item in _box.values) {
        total += item.totalPrice;
      }
      return total;
    } catch (e) {
      print(' Cart Error: $e');
      return 0.0;
    }
  }

  Future<void> clear() async {
    try {
      await _box.clear();
      print('Cart: Cleared all items');
    } catch (e) {
      print('Cart Error: $e');
    }
  }
}