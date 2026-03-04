
import 'package:dartz/dartz.dart';

import '../entities/product_entity.dart';

abstract class IProductRepository {
  Future<Either<String, List<ProductEntity>>> getProducts({
    required int limit,
    required int offset,
  });
}