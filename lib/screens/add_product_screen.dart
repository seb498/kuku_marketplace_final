import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedCategory = 'Eggs';
  String _selectedSubcategory = '';
  bool _isLoading = false;

  final Map<String, List<String>> _subcategories = {
    'Eggs': ['Improved Kienyeji', 'Kienyeji', 'Grade 1'],
    'Live Chicken': ['Broilers', 'Layers', 'Improved Kienyeji', 'Cockerels'],
    'Meat': ['Broiler Meat', 'Kienyeji Meat', 'Grade 1 Chicken Meat'],
  };

  String get unit {
    if (_selectedCategory == 'Eggs') return 'Crate';
    if (_selectedCategory == 'Meat') return 'Kg';
    return 'Bird';
  }

  @override
  void initState() {
    super.initState();
    _selectedSubcategory = _subcategories[_selectedCategory]!.first;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final productCollection = FirebaseFirestore.instance.collection(
        'products',
      );

      final query = await productCollection
          .where('farmerId', isEqualTo: user.uid)
          .where('category', isEqualTo: _selectedCategory)
          .where('subcategory', isEqualTo: _selectedSubcategory)
          .limit(1)
          .get();

      final price = double.parse(_priceController.text.trim());
      final quantity = int.parse(_quantityController.text.trim());

      if (query.docs.isNotEmpty) {
        // ✅ RESTOCK existing product
        final doc = query.docs.first;
        final currentQty = doc['quantity'] ?? 0;

        await productCollection.doc(doc.id).update({
          'quantity': currentQty + quantity,
          'price': price, // update price too
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅ Product restocked!")));
      } else {
        // 🆕 ADD new product
        final productData = {
          'name': _selectedSubcategory,
          'category': _selectedCategory,
          'subcategory': _selectedSubcategory,
          'unit': unit,
          'price': price,
          'quantity': quantity,
          'imageUrl': '',
          'farmerId': user.uid,
        };

        await productCollection.add(productData);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅ Product added!")));
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.green.shade50,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Select Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _subcategories.keys.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                    _selectedSubcategory = _subcategories[val]!.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Select Subcategory",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedSubcategory,
                items: _subcategories[_selectedCategory]!
                    .map(
                      (sub) => DropdownMenuItem(value: sub, child: Text(sub)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedSubcategory = val!),
              ),
              const SizedBox(height: 16),
              Text(
                "Selling Unit: $unit",
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price per $unit",
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter price" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: "Available Quantity ($unit)",
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter quantity" : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.add),
                      label: const Text("Submit Product"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
