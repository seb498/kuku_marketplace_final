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
    final total = (data['total'] as num).toDouble();

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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          automaticallyImplyLeading: false,
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
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('customerId', isEqualTo: currentUser.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
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

              final productImage =
                  (data['productImage'] as String?)?.isNotEmpty == true
                  ? data['productImage'] as String
                  : '';
              final productName =
                  data['productName'] as String? ?? 'Unknown Product';
              final quantity = data['quantity']?.toString() ?? '0';
              final total = data['total']?.toString() ?? '0';
              final isPaid = data['isPaid'] as bool? ?? false;
              final isRated = data['isRated'] as bool? ?? false;

              final timestamp = data['timestamp']?.toDate();
              final formattedDate = timestamp != null
                  ? "${timestamp.toLocal()}".split('.')[0]
                  : "Unknown Date";

              Widget leadingWidget;

              if (productImage.isNotEmpty) {
                leadingWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    productImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green.shade300,
                        child: Text(
                          productName.isNotEmpty
                              ? productName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                leadingWidget = CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green.shade300,
                  child: Text(
                    productName.isNotEmpty ? productName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: leadingWidget,
                        title: Text(
                          productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Qty: $quantity  •  Total: Ksh $total"),
                            Text("Date: $formattedDate"),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            isPaid ? "Paid" : "Unpaid",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: isPaid ? Colors.green : Colors.red,
                        ),
                      ),

                      if (!isPaid)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => markOrderAsPaid(order, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
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
                              backgroundColor: Colors.orange[700],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: const Text("Rate Farmer"),
                          ),
                        ),

                      if (isPaid && isRated)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
