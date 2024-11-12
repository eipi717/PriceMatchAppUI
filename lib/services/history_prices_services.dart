import 'package:dio/dio.dart';
import 'package:price_match_app_ui/models/history_price.dart';
import 'package:price_match_app_ui/models/price.dart';
import 'package:price_match_app_ui/models/product.dart';

class HistoryPricesServices {

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.0.34:8080/api/v1/historicalPrice',
      headers: {'Content-Type': 'application/json'},
    ),
  );

// Function to fetch the list of users
  Future<List<HistoryPrice>> getPricesByProductName(String productName) async {
    final response = await dio.get('/getByProductName?productName=${productName}&sortBy=dataId&orderBy=DESC');
    List<HistoryPrice> priceList = HistoryPrice.fromJsonList(response.data['data']);

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