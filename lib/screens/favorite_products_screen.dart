import 'package:arcitech/screens/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/home_screen_controller.dart';
import '../models/products.dart';

class FavoriteProductsScreen extends StatefulWidget {
  FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  void initState() {
    homeScreenController.fetchFavoriteProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Products"),
      ),
      body: Obx(() => Visibility(
            replacement: const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            )),
            visible: !homeScreenController.isProductsLoading.value,
            child: ListView.builder(
              itemCount: homeScreenController.favoriteProductResponse.length,
              itemBuilder: (context, index) {
                Product product = Product.fromJson(homeScreenController
                        .favoriteProductResponse[index]
                        .data() ??
                    {});
                return InkWell(
                  onTap: () => Get.to(() => ProductDetailScreen(
                        product: product,
                      )),
                  child: Card(
                    elevation: 3.0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      trailing: InkWell(
                          onTap: () {
                            homeScreenController.addProductsToFavorite(product);
                          },
                          child: const Icon(Icons.favorite,color: Colors.red,)),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          product.images?[0] ?? "",
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent?
                              loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return CircularProgressIndicator(
                              color: Colors.blue,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          },
                          // placeholder: 'https://via.placeholder.com/150', // Placeholder image
                          // image: product.images?[0] ?? "",
                          // width: 80,
                          // height: 80,
                          // fit: BoxFit.cover,
                          // placeholder: '\u{23F3}',
                        ),
                      ),
                      title: Text(product.title ?? ""),
                      subtitle: Text(product.description ?? ""),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
