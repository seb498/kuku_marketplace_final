import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerOrdersScreen extends StatelessWidget {
  const FarmerOrdersScreen({super.key});

  Future<void> _releaseOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'isReleased': true},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order released to customer")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to release order: $e")));
    }
  }

  Widget _fallbackImage(String name) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.green.shade300,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in as a farmer")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Orders"),
        backgroundColor: Colors.green.shade700,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('farmerId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final productName = data['productName'] ?? 'Product';
              final quantity = data['quantity'] ?? 0;
              final total = data['total'] ?? 0.0;
              final isReleased = data['isReleased'] ?? false;
              final customerId = data['customerId'] ?? 'N/A';
              final productImage = data['productImage'] ?? '';
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
              final date = timestamp != null
                  ? "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}"
                  : "Unknown";

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  leading: productImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            productImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _fallbackImage(productName),
                          ),
                        )
                      : _fallbackImage(productName),
                  title: Text(productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Qty: $quantity | Total: Ksh $total"),
                      Text("Customer ID: $customerId"),
                      Text("Date: $date"),
                    ],
                  ),
                  trailing: isReleased
                      ? const Text(
                          "Released",
                          style: TextStyle(color: Colors.green),
                        )
                      : ElevatedButton(
                          onPressed: () =>
                              _releaseOrder(context, orders[index].id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                          ),
                          child: const Text("Release"),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
