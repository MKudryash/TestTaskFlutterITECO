import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../services/api_service.dart';

class ProductRepository implements IProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  @override
  Future<List<ProductEntity>> getProducts({int limit = 10, int offset = 0}) async {
    try {
      final products = await _apiService.getProducts(limit: limit, offset: offset);
      return products.map((product) => product.toEntity()).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки продуктов $e');
    }
  }
}