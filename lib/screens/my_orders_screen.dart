import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  Future<void> markOrderAsPaid(
    DocumentSnapshot order,
    BuildContext context,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: const Text(
          "Are you sure you want to mark this order as paid?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Pay"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final orderId = order.id;
    final data = order.data() as Map<String, dynamic>;
    final total = (data['total'] as num?)?.toDouble() ?? 0.0;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {
          'isPaid': true,
          'commission': total * 0.10,
          'farmerAmount': total * 0.90,
        },
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Order marked as paid")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to update order: $e")));
    }
  }

  Future<void> markAsReceived(
    DocumentSnapshot order,
    BuildContext context,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .update({'isReceived': true});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Marked as received")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed: $e")));
    }
  }

  Future<void> showRatingDialog(
    BuildContext context,
    DocumentSnapshot order,
    Map<String, dynamic> data,
  ) async {
    int selectedRating = 5;
    final commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate the Farmer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Order: ${data['productName'] ?? 'Product'}"),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index + 1 <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () =>
                            setState(() => selectedRating = index + 1),
                      );
                    }),
                  );
                },
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                final farmerId = data['farmerId'];
                if (uid == null || farmerId == null) return;

                try {
                  await FirebaseFirestore.instance
                      .collection('ratings')
                      .doc(farmerId)
                      .collection('reviews')
                      .add({
                        'customerId': uid,
                        'rating': selectedRating,
                        'comment': commentController.text.trim(),
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(order.id)
                      .update({'isRated': true});

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Rating submitted")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view your orders.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('customerId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final product = data['productName'] ?? '';
              final image = data['productImage'] ?? '';
              final qty = data['quantity'] ?? 0;
              final double total = (data['total'] as num?)?.toDouble() ?? 0.0;
              final unit = data['unit'] ?? 'Unit';
              final isPaid = data['isPaid'] ?? false;
              final isReleased = data['isReleased'] ?? false;
              final isReceived = data['isReceived'] ?? false;
              final isRated = data['isRated'] ?? false;

              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
              final dateStr = timestamp != null
                  ? "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}"
                  : "Unknown date";

              Widget buildImage() {
                if (image.isEmpty) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Text(
                      product.isNotEmpty ? product[0].toUpperCase() : "?",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: Text(
                        product.isNotEmpty ? product[0].toUpperCase() : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: buildImage(),
                        title: Text(
                          product,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Qty: $qty $unit • Ksh $total"),
                        trailing: Chip(
                          label: Text(
                            isPaid ? "Paid" : "Unpaid",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: isPaid ? Colors.green : Colors.red,
                        ),
                      ),
                      Text("Date: $dateStr"),
                      const SizedBox(height: 10),

                      if (!isReleased)
                        const Text(
                          "⏳ Waiting for farmer to release...",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (isReleased && !isReceived)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => markAsReceived(order, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                            ),
                            child: const Text("Mark as Received"),
                          ),
                        ),
                      if (isReceived && !isPaid)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => markOrderAsPaid(order, context),
                            child: const Text("Pay Now"),
                          ),
                        ),
                      if (isPaid && !isRated)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () =>
                                showRatingDialog(context, order, data),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text("Rate Farmer"),
                          ),
                        ),
                      if (isPaid && isRated)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "✅ Thank you for rating!",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
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
