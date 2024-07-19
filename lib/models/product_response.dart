
import 'package:arcitech/models/products.dart';

class ProductResponse {
  List<Product?>? products;
  num? total;
  num? skip;
  num? limit;

  ProductResponse({this.products, this.total, this.skip, this.limit});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['products'] =products != null ? products!.map((v) => v?.toJson()).toList() : null;
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}