import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RateFarmerScreen extends StatefulWidget {
  final String farmerId;
  final String orderId; // 👈 New

  const RateFarmerScreen({
    super.key,
    required this.farmerId,
    required this.orderId,
  });

  @override
  State<RateFarmerScreen> createState() => _RateFarmerScreenState();
}

class _RateFarmerScreenState extends State<RateFarmerScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a star rating")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      // Save the rating to the farmer's collection
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(widget.farmerId)
          .collection('reviews')
          .add({
            'stars': _rating,
            'review': _reviewController.text.trim(),
            'customerId': user.uid,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Update the order document to mark it as rated
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({'isRated': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thanks for your feedback!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Farmer"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "How was your experience?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(
                    _rating > i ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () => setState(() => _rating = i + 1),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Leave a comment (optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    onPressed: _submitRating,
                    child: const Text(
                      "Submit Rating",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
