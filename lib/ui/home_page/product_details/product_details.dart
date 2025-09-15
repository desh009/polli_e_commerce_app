import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const ProductDetailsPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(image, width: double.infinity, height: 250, fit: BoxFit.cover),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(subtitle, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add to cart or order confirm action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Add to Cart"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
