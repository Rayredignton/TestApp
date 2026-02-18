// lib/features/feed/presentation/feed_vm.dart
import 'package:flutter/material.dart';
import 'package:pawltest/core/locator.dart';
import 'package:pawltest/features/feed/data/product_model.dart';
import 'package:pawltest/features/feed/data/product_repo.dart';

class FeedVm extends ChangeNotifier {
  final repo = locator<ProductRepo>();
  final scrollController = ScrollController();

  List<ProductModel> _items = [];
  List<ProductModel> get items => _items;

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _selected = 'all';
  String get selectedCategory => _selected;

  bool _loading = false;
  bool get loading => _loading;

  bool _end = false;
  int _skip = 0;

  FeedVm() {
    scrollController.addListener(_onScroll);
    _init();
  }

  Future<void> _init() async {
    await _loadCategories();
    await loadMore();
  }

  Future<void> _loadCategories() async {
    _categories = await repo.getCategories();
    _categories.insert(0, 'all');
    notifyListeners();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels > scrollController.position.maxScrollExtent - 300) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (_loading || _end) return;

    _loading = true;
    notifyListeners();

    List<ProductModel> result;
    
    if (_selected == 'all') {
      result = await repo.getProducts(_skip);
    } else {
      result = await repo.getProductsByCategory(_selected, _skip);
    }
    
    if (result.length < 10) _end = true;

    _items.addAll(result);
    _skip += 10;
    _loading = false;

    notifyListeners();
  }

  Future<void> selectCategory(String cat) async {
    if (_selected == cat) return;
    
    _selected = cat;
    _items = [];
    _skip = 0;
    _end = false;
    
    notifyListeners();
    await loadMore();
  }

  Future<void> refresh() async {
    _items.clear();
    _skip = 0;
    _end = false;
    await loadMore();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}