import 'package:equatable/equatable.dart';
import 'driver.dart';

class DriversEntity extends Equatable {
  final bool success;
  final String message;
  final List<Driver> drivers;

  const DriversEntity({
    required this.success,
    required this.message,
    required this.drivers,
  });

  factory DriversEntity.fromJson(Map<String, dynamic> json) {
    final driversList = (json['data'] as List<dynamic>)
        .map((driverJson) => Driver.fromJson(driverJson))
        .toList();
    return DriversEntity(
      success: json['success'] as bool,
      message: json['message'] as String,
      drivers: driversList,
    );
  }

  @override
  List<Object?> get props => [success, message, drivers];
}
