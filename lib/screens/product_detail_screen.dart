import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'chat_screen.dart'; // ✅ Import the chat screen

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  Future<List<Map<String, dynamic>>> _getReviews(String farmerId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .doc(farmerId)
        .collection('reviews')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Widget _buildPlaceholderImage(String name) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 64,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl, String name) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage(name);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderImage(name),
      ),
    );
  }

  Widget _buildRatingStars(double avg) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          size: 20,
          color: avg > index ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getReviews(product.farmerId),
          builder: (context, snapshot) {
            final reviews = snapshot.data ?? [];
            final avgRating = reviews.isNotEmpty
                ? reviews
                          .map((r) => r['rating'] ?? 0)
                          .cast<num>()
                          .reduce((a, b) => a + b) /
                      reviews.length
                : 0.0;

            return ListView(
              children: [
                _buildProductImage(product.imageUrl, product.name),
                const SizedBox(height: 16),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ksh ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text("Category: ${product.description}"),
                Text("Available Quantity: ${product.quantity}"),
                const SizedBox(height: 8),
                _buildRatingStars(avgRating),
                Text(
                  "(${reviews.length} review${reviews.length == 1 ? '' : 's'})",
                ),
                const SizedBox(height: 20),
                const Text(
                  "Customer Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...reviews.map((r) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(r['comment'] ?? 'No comment'),
                      subtitle: Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 16,
                            color: (r['rating'] ?? 0) > index
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          currentUserId: currentUser.uid,
                          otherUserId: product.farmerId,
                          otherUserName: product.name,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text("Chat with Farmer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
