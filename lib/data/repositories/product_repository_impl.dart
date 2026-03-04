import 'package:dartz/dartz.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<ProductEntity>>> getProducts({
    required int limit,
    required int offset,
  }) async {
    try {
      if (limit <= 0 || limit > 20) {
        return Left('Invalid limit. Must be between 1 and 20');
      }

      if (offset < 0) {
        return Left('Invalid offset. Must be non-negative');
      }

      final models = await remoteDataSource.getProducts(limit, offset);

      final entities = models.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left('Error loading products: $e');
    }
  }
}