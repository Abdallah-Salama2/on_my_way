import 'package:equatable/equatable.dart';

import 'product.dart';

class FavoritesEntity extends Equatable {
  const FavoritesEntity({
    required this.success,
    required this.message,
    required this.items,
  });

  final bool success;
  final String message;
  final List<Product> items;

  FavoritesEntity copyWith({
    bool? success,
    String? message,
    List<Product>? items,
  }) {
    return FavoritesEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }

  factory FavoritesEntity.fromJson(Map<String, dynamic> json) {
    return FavoritesEntity(
      success: json["success"],
      message: json["message"],
      items: json["data"]["favorites"] == null
          ? []
          : List<Product>.from(json["data"]["favorites"]
            .where((x) => x["favoritable"] != null)
            .map((x) => Product.fromJson(x["favoritable"]))),
    );
  }


  @override
  List<Object?> get props => [
        success,
        message,
        items,
      ];
}
