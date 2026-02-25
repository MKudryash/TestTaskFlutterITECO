import 'package:dio/dio.dart';
import '../../core/constants/AppConstants.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<List<Product>> getProducts({int limit = 10, int offset = 0}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки продуктов');
      }
    } on DioException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    }
  }
}