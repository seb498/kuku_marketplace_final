import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _deleteUser(BuildContext context, String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ User deleted")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to delete user: $e")));
    }
  }

  Future<double> _getTotalAdminFees() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .get();
    double total = 0;

    for (var doc in snapshot.docs) {
      final fee = doc.data()['adminFee'];
      if (fee is num) total += fee.toDouble();
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        color: Colors.green.shade50,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ✅ Admin Earnings Summary
            FutureBuilder<double>(
              future: _getTotalAdminFees(),
              builder: (context, snapshot) {
                final total = snapshot.data ?? 0.0;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.monetization_on,
                      color: Colors.green,
                      size: 36,
                    ),
                    title: const Text(
                      "Total Admin Fees Collected",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Ksh ${total.toStringAsFixed(2)}"),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// 👥 Users
            const Text(
              '👥 All Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("❌ Failed to load users."));
                }

                final users = snapshot.data?.docs ?? [];
                if (users.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                return Column(
                  children: users.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final uid = doc.id;
                    final email = data['email'] ?? 'N/A';
                    final role = data['role'] ?? 'unknown';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(email),
                        subtitle: Text("Role: $role"),
                        trailing: currentUser?.uid == uid
                            ? const Text("👤 You")
                            : IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteUser(context, uid),
                              ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text(
              '📦 All Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("❌ Failed to load products."),
                  );
                }

                final products = snapshot.data?.docs ?? [];
                if (products.isEmpty) {
                  return const Center(child: Text("No products found."));
                }

                return Column(
                  children: products.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unknown';
                    final desc = data['description'] ?? 'No description';
                    final price = data['price']?.toString() ?? 'N/A';
                    final qty = data['quantity']?.toString() ?? 'N/A';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.shopping_bag, color: Colors.white),
                        ),
                        title: Text(name),
                        subtitle: Text("$desc\nPrice: Ksh $price • Qty: $qty"),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text(
              '🧾 All Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("❌ Failed to load orders."));
                }

                final orders = snapshot.data?.docs ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text("No orders found."));
                }

                return Column(
                  children: orders.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final product = data['productName'] ?? 'Unknown';
                    final customerId = data['customerId'] ?? 'N/A';
                    final qty = data['quantity']?.toString() ?? 'N/A';
                    final total = data['total']?.toString() ?? 'N/A';
                    final fee = data['adminFee']?.toStringAsFixed(2) ?? '0.00';
                    final timestamp = data['timestamp']?.toDate();
                    final date = timestamp != null
                        ? timestamp.toLocal().toString().split('.')[0]
                        : 'N/A';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.receipt, color: Colors.white),
                        ),
                        title: Text(product),
                        subtitle: Text(
                          "Customer ID: $customerId\nQty: $qty • Total: Ksh $total\nAdmin Fee: Ksh $fee\nDate: $date",
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
