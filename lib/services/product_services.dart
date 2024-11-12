import 'package:dio/dio.dart';
import 'package:price_match_app_ui/models/product.dart';

class ProductServices {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8080/api/v1/products',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Product>> getAllProductsWithPrice(int page, int item) async {
    final response =
        await dio.get('/getAllProductsWithPrice?page=${page}&item=${item}');
    List<Product> productList = Product.fromJsonDTOList(response.data['data']);

    return productList;
  }

  Future<void> createProduct() async {
    try {
      final response = await dio.post('/testposting', data: 'helo!');
      return response.data;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<List<Product>> searchProduct(String query) async {
    final response = await dio.get('/searchProduct?query=${query}');
    List<Product> productList = Product.fromJsonDTOList(response.data['data']);

    return productList;
  }
}
