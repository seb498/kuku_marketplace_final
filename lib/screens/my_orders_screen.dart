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
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Yes, Pay"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final orderId = order.id;
    final data = order.data() as Map<String, dynamic>;
    final total = (data['total'] as num?)?.toDouble() ?? 0.0;

    final commission = total * 0.10;
    final farmerAmount = total * 0.90;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {
          'isPaid': true,
          'commission': commission,
          'farmerAmount': farmerAmount,
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
                      final starIndex = index + 1;
                      return IconButton(
                        icon: Icon(
                          starIndex <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = starIndex;
                          });
                        },
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
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                final customerId = FirebaseAuth.instance.currentUser?.uid;
                if (customerId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("You must be logged in")),
                  );
                  return;
                }

                final farmerId = data['farmerId'] as String?;
                if (farmerId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Farmer ID missing")),
                  );
                  return;
                }

                final reviewData = {
                  'customerId': customerId,
                  'rating': selectedRating,
                  'comment': commentController.text.trim(),
                  'timestamp': FieldValue.serverTimestamp(),
                };

                try {
                  await FirebaseFirestore.instance
                      .collection('ratings')
                      .doc(farmerId)
                      .collection('reviews')
                      .add(reviewData);

                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(order.id)
                      .update({'isRated': true});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your rating!')),
                  );

                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit rating: $e')),
                  );
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
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Orders"),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text("You must be logged in to view orders."),
        ),
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
            .where('customerId', isEqualTo: currentUser.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final productName = data['productName'] ?? 'Product';
              final image = data['productImage'] ?? '';
              final quantity = data['quantity'] ?? 0;
              final total = data['total'] ?? 0.0;
              final isPaid = data['isPaid'] ?? false;
              final isRated = data['isRated'] ?? false;
              final unit = data['unit'] ?? 'Unit';
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
              final formattedDate = timestamp != null
                  ? "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}"
                  : 'Unknown Date';

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: image != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.green.shade300,
                                    child: Text(
                                      productName[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green.shade300,
                                child: Text(
                                  productName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        title: Text(
                          productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Qty: $quantity $unit • Ksh $total"),
                        trailing: Chip(
                          label: Text(
                            isPaid ? "Paid" : "Unpaid",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: isPaid
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text("Date: $formattedDate"),
                      ),
                      const SizedBox(height: 6),
                      if (!isPaid)
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
                              backgroundColor: Colors.orange[800],
                            ),
                            child: const Text("Rate Farmer"),
                          ),
                        ),
                      if (isPaid && isRated)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 12),
                          child: Text(
                            "Thank you for rating!",
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
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
