class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }
}
