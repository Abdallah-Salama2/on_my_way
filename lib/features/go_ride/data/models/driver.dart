import 'package:equatable/equatable.dart';

import 'place.dart';
import 'vehicle.dart';

class Driver extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String licenseNumber;
  final Place location;
  final Vehicle vehicle;
  final double price;

  const Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.location,
    required this.vehicle,
    required this.price,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['driver']['id'],
      name: json['driver']['name'],
      email: json['driver']['email'],
      phone: json['driver']['phone'],
      licenseNumber: json['driver']['license_number'],
      location: Place.fromJson(json['driver']['location']),
      vehicle: Vehicle.fromJson(json['driver']['vehicle']),
      price:double.parse(json['price'].toString()) 
    );
  }

  @override
  bool? get stringify => false;

  @override
  List<Object?> get props =>
      [id, name, email, phone, licenseNumber, location, vehicle];
}
