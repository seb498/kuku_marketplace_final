import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'logout_screen.dart';
import 'my_orders_screen.dart';
import 'place_order_screen.dart';
import 'product_detail_screen.dart';
import 'profile_update_screen.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Eggs', 'Meat', 'Live Chicken'];

  Stream<List<Product>> _getProducts() {
    return FirebaseFirestore.instance.collection('products').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .where((product) {
            final matchesSearch =
                _searchQuery.isEmpty ||
                product.name.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesCategory =
                _selectedCategory == 'All' ||
                product.productType.toLowerCase() ==
                    _selectedCategory.toLowerCase();
            return matchesSearch && matchesCategory;
          })
          .toList();
    });
  }

  Future<Map<String, dynamic>> _getFarmerRating(String farmerId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .doc(farmerId)
        .collection('reviews')
        .get();

    if (snapshot.docs.isEmpty) return {'average': 0.0, 'count': 0};

    double total = 0;
    for (var doc in snapshot.docs) {
      final rating = doc.data()['rating'];
      if (rating is num) total += rating.toDouble();
    }

    double average = total / snapshot.docs.length;
    return {'average': average, 'count': snapshot.docs.length};
  }

  Widget _placeholderImage(String name) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl, String name) {
    if (imageUrl.isEmpty) return _placeholderImage(name);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(name),
      ),
    );
  }

  Widget _buildRatingStars(double avg, int count) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            Icons.star,
            size: 18,
            color: avg >= index + 1 ? Colors.orange : Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Text("($count)", style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: false,
        title: const Text("🐓 Customer Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileUpdateScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: "My Orders",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LogoutScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: const InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(child: Text("No products available."));
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final inStock = product.quantity > 0;

                      return FutureBuilder<Map<String, dynamic>>(
                        future: _getFarmerRating(product.farmerId),
                        builder: (context, ratingSnap) {
                          final rating =
                              ratingSnap.data ?? {'average': 0.0, 'count': 0};
                          final avg = rating['average'] as double;
                          final count = rating['count'] as int;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: _buildProductImage(
                                      product.imageUrl,
                                      product.name,
                                    ),
                                    title: Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Ksh ${product.price} • Qty: ${product.quantity}",
                                        ),
                                        Text(
                                          "Category: ${product.productType} (${product.category})",
                                        ),
                                        Text("Sold in ${product.unit}"),
                                        const SizedBox(height: 4),
                                        _buildRatingStars(avg, count),
                                      ],
                                    ),
                                    trailing: inStock
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      PlaceOrderScreen(
                                                        product: product,
                                                      ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green[700],
                                            ),
                                            child: const Text("Order"),
                                          )
                                        : const Text(
                                            "Out of Stock",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailScreen(
                                              product: product,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("View Details"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
