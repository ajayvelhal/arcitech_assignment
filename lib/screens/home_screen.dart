import 'dart:developer';

import 'package:arcitech/controller/home_screen_controller.dart';
import 'package:arcitech/models/products.dart';
import 'package:arcitech/screens/product_detail_screen.dart';
import 'package:arcitech/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'favorite_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    homeScreenController.fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          InkWell(
            onTap: () => Get.to(() => FavoriteProductsScreen()),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.favorite_border),
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => const ProfileScreen()),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.person_3_outlined),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => homeScreenController.search(value),
              // Call search function on text change
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => Visibility(
                  replacement: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  )),
                  visible: !homeScreenController.isProductsLoading.value,
                  child: homeScreenController.filteredItems.isEmpty
                      ? const Center(child: Text('No items found'))
                      : ListView.builder(
                          itemCount: homeScreenController.filteredItems.length,
                          itemBuilder: (context, index) {
                            Product product =
                                homeScreenController.filteredItems[index];
                            return InkWell(
                              onTap: () => Get.to(() => ProductDetailScreen(
                                    product: product,
                                  )),
                              child: Card(
                                elevation: 3.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  trailing: InkWell(
                                      onTap: () {
                                        homeScreenController
                                            .addProductsToFavorite(product);
                                      },
                                      child: const Icon(Icons.favorite_border)),
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
          ),
        ],
      ),
    );
  }
}
