import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Product product;

  const PlaceOrderScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _quantityController = TextEditingController();
  bool _isSubmitting = false;

  Widget _placeholderImage(String productName) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        productName.isNotEmpty ? productName[0].toUpperCase() : '?',
        style: const TextStyle(fontSize: 64, color: Colors.white),
      ),
    );
  }

  Future<void> _submitOrder() async {
    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid quantity")));
      return;
    }

    if (quantity > widget.product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot order more than available stock (${widget.product.quantity})",
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final firestore = FirebaseFirestore.instance;
      final productRef = firestore
          .collection('products')
          .doc(widget.product.id);

      // ✅ Step 1: Atomically reduce stock
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(productRef);
        final currentStock = snapshot.get('quantity');

        if (currentStock < quantity) {
          throw Exception("Not enough stock available.");
        }

        transaction.update(productRef, {'quantity': currentStock - quantity});
      });

      // ✅ Step 2: Calculate splits
      final totalAmount = quantity * widget.product.price;
      final adminFee = totalAmount * 0.10;
      final farmerAmount = totalAmount - adminFee;

      // ✅ Step 3: Save order
      final orderData = {
        'productId': widget.product.id,
        'productName': widget.product.name,
        'productImage': widget.product.imageUrl,
        'quantity': quantity,
        'price': widget.product.price,
        'total': totalAmount,
        'adminFee': adminFee,
        'farmerAmount': farmerAmount,
        'customerId': user.uid,
        'farmerId': widget.product.farmerId,
        'timestamp': FieldValue.serverTimestamp(),
        'isPaid': false,
        'isRated': false,
      };

      await firestore.collection('orders').add(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order placed successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("❌ Error placing order: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to place order: $e")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Your Order"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: product.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _placeholderImage(product.name),
                      ),
                    )
                  : _placeholderImage(product.name),
            ),
            const SizedBox(height: 20),
            Text(
              "Product: ${product.name}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              "Price: Ksh ${product.price}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Quantity (Available: ${product.quantity})",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green[700],
                      ),
                      child: const Text("Place Order"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
