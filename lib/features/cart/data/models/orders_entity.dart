import 'package:equatable/equatable.dart';
import 'package:on_my_way/features/cart/data/models/food_order.dart';
import 'package:on_my_way/features/cart/data/models/ride_order.dart';

class OrdersEntity extends Equatable {
  final bool success;
  final String message;
  final List<FoodOrderModel> items;
  final List<RideOrderModel> rides;

  const OrdersEntity({
    required this.success,
    required this.message,
    required this.items,
    required this.rides,
  });

  OrdersEntity copyWith({
    bool? success,
    String? message,
    List<FoodOrderModel>? items,
    List<RideOrderModel>? rides,
  }) {
    return OrdersEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      items: items ?? this.items,
      rides: rides ?? this.rides,
    );
  }

  factory OrdersEntity.fromJson(Map<String, dynamic> json, bool isFood) {
    return OrdersEntity(
      success: json["success"],
      message: json["message"],
      rides: isFood
          ? []
          : List<RideOrderModel>.from(
              json["data"].map((x) => RideOrderModel.fromJson(x)),
            ),
      items: !isFood
          ? []
          : List<FoodOrderModel>.from(
              json["data"].map((x) => FoodOrderModel.fromJson(x)),
            ),
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        items,
        rides,
      ];
}
