import 'package:arcitech/models/product_response.dart';
import 'package:arcitech/models/products.dart';
import 'package:arcitech/services/products_api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController{
  final ProductsApiService _apiService  = ProductsApiService();

  Rx<ProductResponse> productResponse = ProductResponse().obs;
  RxBool isProductsLoading = false.obs;
  RxList<Product> filteredItems = <Product>[].obs;
  RxList<Product> products = <Product>[].obs;
  RxList<DocumentSnapshot<Map<String, dynamic>>> favoriteProductResponse = <DocumentSnapshot<Map<String, dynamic>>>[].obs;

  fetchAllProducts() async {
    try{
      isProductsLoading(true);
      productResponse.value = await _apiService.fetchAllProducts();
      productResponse.value.products?.forEach((item){
        filteredItems.add(item ?? Product());
        products.add(item ?? Product());

      });
      isProductsLoading(false);
    }
    catch(e){
      isProductsLoading(false);
    }

  }

  void search(String keyword) {
    if (keyword.isEmpty) {
      // Reset filteredItems to all items when keyword is empty
      // filteredItems.assignAll(items);
    } else {
      // Filter items based on keyword
      filteredItems.assignAll(products.where((item) =>
      item.title?.toLowerCase().contains(keyword.toLowerCase()) ?? false ||
          item.description!.toLowerCase().contains(keyword.toLowerCase())));
    }
  }
  addProductsToFavorite(Product product) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites')
        .doc(product.id.toString())
        .set(product.toJson());
    Get.snackbar("Success", "Added to favorites");
  }

  fetchFavoriteProducts() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites')
        .snapshots().listen((snapshot){
     favoriteProductResponse.assignAll(snapshot.docs);
   });

   print(favoriteProductResponse.length);
  }
}