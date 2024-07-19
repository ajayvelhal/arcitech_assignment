import 'package:arcitech/models/products.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Main Image
            Image.network(
              product.images?[0] ?? "",
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),

            // Title
            Text(
              product.title ?? "",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),

            // Description
            Text(
              product.description ?? "",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16.0),

            // Additional Images (if available)
            // Replace with your implementation for additional images
            // For example, you can use a ListView.builder or CarouselSlider
            // to display additional images in a gallery style.

            // Other Details (e.g., price, category)
            // Replace with your implementation for other details
            // Example:
            Text(
              'Price: \$${product.price}', // Example for price
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Category: ${product.category}', // Example for category
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
