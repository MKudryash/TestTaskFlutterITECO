import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../repositories/i_product_repository.dart';

class GetProductsUseCase {
  final IProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<String, List<ProductEntity>>> call({
    required int limit,
    required int offset,
  }) {
    if (offset < 0 || limit <= 0) {
      return Future.value(Left('Invalid pagination parameters'));
    }

    return repository.getProducts(limit: limit, offset: offset);
  }
}