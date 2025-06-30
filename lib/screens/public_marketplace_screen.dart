import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../models/product_model.dart';

class PublicMarketplaceScreen extends StatefulWidget {
  const PublicMarketplaceScreen({super.key});

  @override
  State<PublicMarketplaceScreen> createState() =>
      _PublicMarketplaceScreenState();
}

class _PublicMarketplaceScreenState extends State<PublicMarketplaceScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Eggs', 'Meat', 'Live Birds'];

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
                product.description.toLowerCase().contains(
                  _selectedCategory.toLowerCase(),
                );
            return matchesSearch && matchesCategory;
          })
          .toList();
    });
  }

  Future<String> _getFarmerEmail(String farmerId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(farmerId)
        .get();
    return doc.data()?['email'] ?? 'Unknown Farmer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public Marketplace"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8BC34A), Color(0xFF558B2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F8E9), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search
            TextField(
              decoration: InputDecoration(
                labelText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 12),

            // Category filter
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Products
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return const Center(
                      child: Text("No products found right now."),
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return FutureBuilder<String>(
                        future: _getFarmerEmail(product.farmerId),
                        builder: (context, farmerSnapshot) {
                          final farmerEmail =
                              farmerSnapshot.data ?? 'Loading...';

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "💲 Ksh ${product.price} • Qty: ${product.quantity}",
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "👨‍🌾 Farmer: $farmerEmail",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF558B2F),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Login\nTo Order",
                                  textAlign: TextAlign.center,
                                ),
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
