import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class CartEntity extends Equatable {
  const CartEntity({
    required this.success,
    required this.message,
    required this.items,
  });

  final bool success;
  final String message;
  final List<CartItem> items;

  num get totalPrice {
    num total = 0;
    for (var element in items) {
      total += element.totalPrice;
    }
    return total;
  }

  CartEntity copyWith({
    bool? success,
    String? message,
    List<CartItem>? items,
  }) {
    return CartEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }

  factory CartEntity.fromJson(Map<String, dynamic> json) {
    return CartEntity(
      success: json["success"],
      message: json["message"],
      items: json["data"] == null
          ? []
          : List<CartItem>.from(json["data"].map((x) => CartItem.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        items,
      ];
}



