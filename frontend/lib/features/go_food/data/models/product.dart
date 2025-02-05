import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String imageUrl;
  final int storeId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final num rating;
  final bool favoriteStats;

  const Product({
    required this.id,
    required this.imageUrl,
    required this.storeId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.favoriteStats,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        imageUrl: json['image_url'] as String,
        storeId: json['store_id'] as int,
        categoryId: json['category_id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        price: json['price'],
        rating: json['rating'],
        favoriteStats: json['favoriteStats'],
      );

  Product copyWith({
    int? id,
    String? imageUrl,
    int? storeId,
    int? categoryId,
    String? name,
    String? description,
    double? price,
    num? rating,
    bool? favoriteStats,
  }) {
    return Product(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      storeId: storeId ?? this.storeId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      favoriteStats: favoriteStats ?? this.favoriteStats,
    );
  }

  
  @override
  bool? get stringify => false;

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        storeId,
        categoryId,
        name,
        description,
        price,
        rating,
        favoriteStats,
      ];
}
