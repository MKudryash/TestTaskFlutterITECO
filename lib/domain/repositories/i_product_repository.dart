import '../entities/product_entity.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> getProducts({int limit = 10, int offset = 0});
}