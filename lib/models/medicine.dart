class Medicine {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final int reviewCount;
  final int stock;
  final String dosage;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.dosage,
  });

  // Factory constructor for creating Medicine from JSON
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      stock: json['stock'] as int,
      dosage: json['dosage'] as String,
    );
  }

  // Convert Medicine to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'dosage': dosage,
    };
  }
}
