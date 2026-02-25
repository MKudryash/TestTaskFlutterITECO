// lib/presentation/feed/feed_view_model.dart
import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_product_repository.dart';

class FeedViewModel extends ChangeNotifier {
  final IProductRepository _repository;

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  String? _error;

  FeedViewModel(this._repository);

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadInitialProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProducts = await _repository.getProducts(limit: 10, offset: 0);
      _products = newProducts;
      for (var i = 0; i < newProducts.length; i++) {
        final product = newProducts[i];
        debugPrint(''' Продукт #${i + 1}: ${product.image}''');
      }

      _currentPage = 1;
      _hasMore = newProducts.isNotEmpty;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _repository.getProducts(
        limit: 10,
        offset: _currentPage * 10,
      );

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
