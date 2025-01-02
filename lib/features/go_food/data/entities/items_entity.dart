import 'package:equatable/equatable.dart';
import 'package:on_my_way/features/go_food/data/models/product.dart';

class CategoryItemsEntity extends Equatable {
  final bool success;
  final String message;
  final String name;
  final String description;
  final int id;
  final List<Product> products;

  const CategoryItemsEntity({
    required this.success,
    required this.message,
    required this.products,
    required this.id,
    required this.description,
    required this.name,
  });

  factory CategoryItemsEntity.fromJson(Map<String, dynamic> json) =>
      CategoryItemsEntity(
        success: json['success'] as bool,
        message: json['message'] as String,
        description: json['data']['description'],
        id: json['data']['id'],
        name: json['data']['name'],
        products: (json['data']['items'] as List<dynamic>)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  CategoryItemsEntity copyWith({
    bool? success,
    String? message,
    List<Product>? products,
    int? id,
    String? description,
    String? name,
  }) {
    return CategoryItemsEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      products: products ?? this.products,
      id: id ?? this.id,
      description: description ?? this.description,
      name: name ?? this.name,
    );
  }

  @override
  bool? get stringify => false;

  @override
  List<Object?> get props => [success, message, products];
}
