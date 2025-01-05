import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final num? orderAmount;
  final DateTime? orderTime;
  final String status;
  final int? id;
  final List<OrderItem> items;

  const OrderModel({
    required this.orderAmount,
    required this.orderTime,
    required this.status,
    required this.id,
    required this.items,
  });

  OrderModel copyWith(
      {num? orderAmount,
      DateTime? orderTime,
      String? status,
      int? id,
      List<OrderItem>? items}) {
    return OrderModel(
      orderAmount: orderAmount ?? this.orderAmount,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      id: id ?? this.id,
      items: items ?? this.items,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderAmount: json["order_amount"] is String
          ? num.parse(json["order_amount"])
          : json["order_amount"],
      orderTime: DateTime.tryParse(json["order_time"] ?? ""),
      status: json["status"],
      id: json["id"],
      items: json['order_items'] == null
          ? []
          : List<OrderItem>.from(
              json["order_items"].map((x) => OrderItem.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        orderAmount,
        orderTime,
        status,
        id,
      ];
}

class OrderItem extends Equatable {
  const OrderItem({
    required this.itemId,
    required this.quantity,
    required this.price,
  });

  final int? itemId;
  final num? quantity;
  final String? price;

  OrderItem copyWith({
    int? itemId,
    num? quantity,
    String? price,
  }) {
    return OrderItem(
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json["item_id"],
      quantity: json["quantity"],
      price: json["price"],
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        quantity,
        price,
      ];
}
