// lib/features/cart/presentation/cart_vm.dart
import 'package:flutter/material.dart';
import 'package:pawltest/core/locator.dart';
import 'package:pawltest/features/cart/data/cart_model.dart';
import 'package:pawltest/features/cart/data/cart_repo.dart';

class CartVm extends ChangeNotifier {

  final repo = locator<CartRepo>();
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  CartVm() {
    _loadCart();
  }

  void _loadCart() {
    _items = repo.getItems();
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    _loading = true;
    notifyListeners();

    await repo.addItem(item);
    _items = repo.getItems();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> removeFromCart(int productId) async {
    await repo.removeItem(productId);
    _items = repo.getItems();
    notifyListeners();
  }

  Future<void> increment(int productId) async {
    final item = _items.firstWhere((i) => i.id == productId);
    await repo.updateQuantity(productId, item.quantity + 1);
    _items = repo.getItems();
    notifyListeners();
  }

  Future<void> decrement(int productId) async {
    final item = _items.firstWhere((i) => i.id == productId);
    if (item.quantity > 1) {
      await repo.updateQuantity(productId, item.quantity - 1);
    } else {
      await repo.removeItem(productId);
    }
    _items = repo.getItems();
    notifyListeners();
  }

  double get total => repo.getTotalPrice();
  
  int get count => repo.getTotalItems();

  Future<void> clearCart() async {
    await repo.clear();
    _items = [];
    notifyListeners();
  }
}