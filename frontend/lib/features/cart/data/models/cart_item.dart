import 'package:equatable/equatable.dart';

import '../../../go_food/data/models/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final num totalPrice;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['item']),
      quantity: json['quantity'],
      totalPrice: json['total_price'],
    );
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    num? totalPrice,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  
  bool? get stringify => false;

  @override
  List<Object?> get props => [product, quantity, totalPrice];
}
