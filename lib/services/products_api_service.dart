import 'package:dio/dio.dart';

import '../models/product_response.dart';
import '../models/products.dart';

class ProductsApiService{

  final Dio dio = Dio();

  Future<ProductResponse> fetchAllProducts() async {

    ProductResponse products = ProductResponse();
    try{

      var response = await dio.get("https://dummyjson.com/products");

      print(response.data);
      products = ProductResponse.fromJson(response.data);
    }catch (e){
      print(e);
    }
    return products;
  }
}