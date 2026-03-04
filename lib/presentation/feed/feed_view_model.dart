import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../core/constants/app_constants.dart';

class FeedViewModel extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  int _currentOffset = 0;
  bool _isDisposed = false;
  Timer? _debounceTimer;

  final Set<int> _productIds = {};

  FeedViewModel(this._getProductsUseCase);

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;

  bool get hasMore => true;

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> loadInitialProducts() async {
    if (_isDisposed) return;

    _isLoading = true;
    _error = null;
    _products.clear();
    _productIds.clear();
    _currentOffset = 0;
    _notifyIfMounted();

    await _loadProducts();
  }

  Future<void> loadMoreProducts() async {

    if (_isLoadingMore || _isLoading || _isDisposed) return;


    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (_isDisposed) return;

      await _loadProducts(isLoadMore: true);
    });
  }

  Future<void> _loadProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      _isLoadingMore = true;
    }
    _notifyIfMounted();

    try {
      final result = await _getProductsUseCase(
        limit: AppConstants.productsPerPage,
        offset: _currentOffset,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => Left('Request timeout'),
      );

      if (_isDisposed) return;

      result.fold(
            (error) {
          _error = error;
          if (isLoadMore) {
            _isLoadingMore = false;
          } else {
            _isLoading = false;
          }
          _notifyIfMounted();
        },
            (newProducts) {
          _processNewProducts(newProducts, isLoadMore);

          if (isLoadMore) {
            _isLoadingMore = false;
          } else {
            _isLoading = false;
          }


          _currentOffset += AppConstants.productsPerPage;

          _notifyIfMounted();
        },
      );
    } catch (e) {
      if (_isDisposed) return;
      _error = e.toString();
      if (isLoadMore) {
        _isLoadingMore = false;
      } else {
        _isLoading = false;
      }
      _notifyIfMounted();
    }
  }

  void _processNewProducts(List<ProductEntity> newProducts, bool isLoadMore) {
    if (!isLoadMore) {

      _products = newProducts;
      _productIds.addAll(newProducts.map((p) => p.id));
    } else {

      for (var product in newProducts) {
        if (!_productIds.contains(product.id)) {
          _products.add(product);
          _productIds.add(product.id);
        }
      }


      if (_products.length == _productIds.length &&
          _products.isNotEmpty &&
          _products.length < _products.length + newProducts.length) {

        _productIds.clear();
        _productIds.addAll(_products.map((p) => p.id));


        _products.addAll(newProducts);
      }
    }
  }

  void clearError() {
    if (_isDisposed) return;
    _error = null;
    _notifyIfMounted();
  }

  Future<void> refreshProducts() async {
    if (_isDisposed) return;

    // Сбрасываем состояние
    _products.clear();
    _productIds.clear();
    _currentOffset = 0;
    _error = null;

    await loadInitialProducts();
  }

  void _notifyIfMounted() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}