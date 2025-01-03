import 'package:equatable/equatable.dart';
import 'package:on_my_way/features/cart/data/models/order.dart';

class OrdersEntity extends Equatable {
  const OrdersEntity({
    required this.success,
    required this.message,
    required this.items,
  });

  final bool success;
  final String message;
  final List<OrderModel> items;

  OrdersEntity copyWith({
    bool? success,
    String? message,
    List<OrderModel>? items,
  }) {
    return OrdersEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }

  factory OrdersEntity.fromJson(Map<String, dynamic> json) {
    return OrdersEntity(
      success: json["success"],
      message: json["message"],
      items: json["data"] == null
          ? []
          : List<OrderModel>.from(
              json["data"].map((x) => OrderModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        items,
      ];
}
