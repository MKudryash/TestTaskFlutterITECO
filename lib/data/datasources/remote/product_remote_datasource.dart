import 'dart:async';
import 'package:dio/dio.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';

abstract class IProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(int limit, int offset);
}

class ProductRemoteDataSource implements IProductRemoteDataSource {
  final ApiService apiService;

  // Кэш для хранения всех продуктов
  List<ProductModel>? _allProductsCache;
  DateTime? _lastFetchTime;
  static const Duration cacheDuration = Duration(minutes: 5);

  ProductRemoteDataSource(this.apiService);

  @override
  Future<List<ProductModel>> getProducts(int limit, int offset) async {
    try {
      // Загружаем все продукты при первом запросе или если кэш устарел
      await _ensureProductsCache();

      if (_allProductsCache == null || _allProductsCache!.isEmpty) {
        return [];
      }

      // Реализуем циклическую пагинацию
      return _getCyclicProducts(limit, offset);

    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return [];
      }
      throw Exception('Failed to load products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<void> _ensureProductsCache() async {
    // Проверяем, нужно ли обновить кэш
    final now = DateTime.now();
    if (_allProductsCache != null &&
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < cacheDuration) {
      return;
    }

    try {
      // Загружаем все продукты одним запросом
      final response = await apiService.get('/products');

      if (response.data is! List) {
        throw Exception('Invalid response format');
      }

      final List<dynamic> data = response.data;
      _allProductsCache = data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _lastFetchTime = now;

      print('Loaded ${_allProductsCache!.length} products to cache');
    } catch (e) {
      print('Error loading products cache: $e');
      rethrow;
    }
  }

  List<ProductModel> _getCyclicProducts(int limit, int offset) {
    if (_allProductsCache == null || _allProductsCache!.isEmpty) {
      return [];
    }

    final totalProducts = _allProductsCache!.length;
    final result = <ProductModel>[];

    for (int i = 0; i < limit; i++) {
      // Вычисляем индекс с циклическим перебором
      final index = (offset + i) % totalProducts;
      result.add(_allProductsCache![index]);
    }

    return result;
  }

  // Метод для принудительного обновления кэша
  Future<void> refreshCache() async {
    _allProductsCache = null;
    _lastFetchTime = null;
    await _ensureProductsCache();
  }
}