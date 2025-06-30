class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  final String farmerId;
  final String? farmerEmail;
  final String productType;
  final String category;
  final String subcategory;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.farmerId,
    this.farmerEmail,
    required this.productType,
    required this.category,
    required this.subcategory,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'farmerId': farmerId,
      if (farmerEmail != null) 'farmerEmail': farmerEmail,
      'productType': productType,
      'category': category,
      'subcategory': subcategory,
      'unit': unit,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: _parsePrice(map['price']),
      quantity: _parseQuantity(map['quantity']),
      imageUrl: map['imageUrl'] ?? '',
      farmerId: map['farmerId'] ?? '',
      farmerEmail: map['farmerEmail'] as String?,
      productType: map['productType'] ?? '',
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      unit: map['unit'] ?? '',
    );
  }

  static double _parsePrice(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _parseQuantity(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? imageUrl,
    String? farmerId,
    String? farmerEmail,
    String? productType,
    String? category,
    String? subcategory,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      farmerId: farmerId ?? this.farmerId,
      farmerEmail: farmerEmail ?? this.farmerEmail,
      productType: productType ?? this.productType,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      unit: unit ?? this.unit,
    );
  }
}
