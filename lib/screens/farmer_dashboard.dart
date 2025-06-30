import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'add_product_screen.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> _getMyProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('farmerId', isEqualTo: currentUser?.uid ?? '')
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> _getInquiries(String farmerId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId', isEqualTo: farmerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          final Map<String, Map<String, dynamic>> latestMessages = {};
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final senderId = data['senderId'] ?? '';
            final message = data['text'] ?? '';
            final timestamp = data['timestamp'];

            if (senderId.isNotEmpty &&
                message.isNotEmpty &&
                timestamp != null &&
                !latestMessages.containsKey(senderId)) {
              latestMessages[senderId] = {
                'lastMessage': message,
                'timestamp': timestamp,
                'customerId': senderId,
              };
            }
          }
          return latestMessages.values.toList();
        });
  }

  Future<String> _getCustomerName(String customerId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(customerId)
        .get();
    return doc.exists ? doc.data()!['name'] ?? 'Unknown' : 'Unknown';
  }

  Future<Map<String, dynamic>> _getMyAverageRating() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .doc(currentUser?.uid)
        .collection('reviews')
        .get();

    if (snapshot.docs.isEmpty) return {'average': 0.0, 'count': 0};

    double total = 0;
    for (var doc in snapshot.docs) {
      final rating = doc.data()['rating'];
      if (rating is num) total += rating.toDouble();
    }

    double avg = total / snapshot.docs.length;
    return {'average': avg, 'count': snapshot.docs.length};
  }

  Future<Map<String, dynamic>> _getMyEarnings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('farmerId', isEqualTo: currentUser?.uid ?? '')
        .get();

    double totalEarnings = 0;
    int totalOrders = snapshot.docs.length;

    for (var doc in snapshot.docs) {
      final farmerAmount = doc.data()['farmerAmount'];
      if (farmerAmount is num) totalEarnings += farmerAmount.toDouble();
    }

    return {'totalEarnings': totalEarnings, 'totalOrders': totalOrders};
  }

  Widget _buildStars(double avg) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          size: 18,
          color: avg >= index + 1 ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final farmerId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('🐓 Farmer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.green.shade50,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
        backgroundColor: Colors.green.shade700,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Rating
            FutureBuilder<Map<String, dynamic>>(
              future: _getMyAverageRating(),
              builder: (context, snapshot) {
                final avg = snapshot.data?['average'] ?? 0.0;
                final count = snapshot.data?['count'] ?? 0;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.orange),
                    title: const Text("Your Average Rating"),
                    subtitle: Row(
                      children: [
                        _buildStars(avg),
                        const SizedBox(width: 8),
                        Text("(${avg.toStringAsFixed(1)}/5, $count reviews)"),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // 💰 Earnings
            FutureBuilder<Map<String, dynamic>>(
              future: _getMyEarnings(),
              builder: (context, snapshot) {
                final total = snapshot.data?['totalEarnings'] ?? 0.0;
                final orders = snapshot.data?['totalOrders'] ?? 0;
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.monetization_on,
                      color: Colors.green,
                    ),
                    title: const Text("Your Total Earnings"),
                    subtitle: Text(
                      "Ksh ${total.toStringAsFixed(2)} from $orders orders",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // 📦 Products
            const Text(
              '📦 My Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                stream: _getMyProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products listed yet.'));
                  }
                  final products = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final data =
                          products[index].data() as Map<String, dynamic>;
                      final name = data['name'] ?? 'N/A';
                      final price = data['price'] ?? 'N/A';
                      final qty = data['quantity'] ?? 0;

                      return Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Price: Ksh $price'),
                                Text('Qty: $qty'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 💬 Inquiries
            const Text(
              '💬 Customer Inquiries',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getInquiries(farmerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No messages yet.');
                }

                final conversations = snapshot.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final convo = conversations[index];
                    final lastMessage = convo['lastMessage'] ?? '';
                    final timestamp = convo['timestamp'];
                    final customerId = convo['customerId'] ?? '';

                    return FutureBuilder<String>(
                      future: _getCustomerName(customerId),
                      builder: (context, nameSnapshot) {
                        final customerName = nameSnapshot.data ?? 'Loading...';

                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(customerName),
                            subtitle: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: timestamp is Timestamp
                                ? Text(
                                    timestamp
                                        .toDate()
                                        .toLocal()
                                        .toString()
                                        .split('.')[0],
                                    style: const TextStyle(fontSize: 10),
                                  )
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    currentUserId: farmerId,
                                    otherUserId: customerId,
                                    otherUserName: customerName,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
