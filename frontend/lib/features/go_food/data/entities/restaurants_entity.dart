import 'package:equatable/equatable.dart';

import 'package:on_my_way/features/go_food/data/models/restaurant.dart';

class RestaurantsEntity extends Equatable {
  final bool success;
  final String message;
  final List<Restaurant> data;

  const RestaurantsEntity({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RestaurantsEntity.fromJson(Map<String, dynamic> json) =>
      RestaurantsEntity(
        success: json['success'] as bool,
        message: json['message'] as String,
        data: (json['data'] as List<dynamic>)
            .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  bool? get stringify => false;

  @override
  List<Object?> get props => [success, message, data];
}
