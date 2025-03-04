import 'package:dio/dio.dart';
import 'package:price_match_app_ui/models/price.dart';
import 'package:price_match_app_ui/models/product.dart';

class PriceServices {
  // TODO: replaced the local address with env
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.0.34:8080/api/v1/prices',
      headers: {'Content-Type': 'application/json'},
    ),
  );

// Function to fetch the list of users
  Future<List<Price>> getPricesByProductName(String productName, int page, int item) async {
    final response = await dio.get('getByProductName?productName=${productName}');
    print('hello');
    List<Price> priceList = Price.fromJsonList(response.data['data']);
    print(priceList);

    return priceList;
  }

// // Function to create a new user
  Future<void> createProduct() async {
    try {
      final response = await dio.post(
          '/testposting',
          data: 'helo!'
      );
      print(response.data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }


}