import 'package:equatable/equatable.dart';
import 'package:on_my_way/features/go_food/data/models/product.dart';
import 'package:on_my_way/features/go_food/data/models/restaurant.dart';

class RestaurantItemsEntity extends Equatable {
  final bool success;
  final String message;
  final Restaurant restaurant;
  final List<Product> products;

  const RestaurantItemsEntity({
    required this.success,
    required this.message,
    required this.products,
    required this.restaurant,
  });

  factory RestaurantItemsEntity.fromJson(Map<String, dynamic> json) =>
      RestaurantItemsEntity(
        success: json['success'] as bool,
        message: json['message'] as String,
        restaurant: Restaurant.fromJson(json['data']),
        products: (json['data']['items'] as List<dynamic>)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  RestaurantItemsEntity copyWith({
    bool? success,
    String? message,
    Restaurant? restaurant,
    List<Product>? items,
  }) {
    return RestaurantItemsEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      restaurant: restaurant ?? this.restaurant,
      products: items ?? this.products,
    );
  }

  @override
  bool? get stringify => false;

  @override
  List<Object?> get props => [success, message, products];
}
