import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final int id;
  final String imageUrl;
  final String type;
  final String model;
  final String color;
  final String registrationNumber;
  final int capacity;

  const Vehicle({
    required this.id,
    required this.imageUrl,
    required this.type,
    required this.model,
    required this.color,
    required this.registrationNumber,
    required this.capacity,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      imageUrl: json['image_url'],
      type: json['type'],
      model: json['model'],
      color: json['color'],
      registrationNumber: json['registration_number'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_url': imageUrl,
        'type': type,
        'model': model,
        'color': color,
        'registration_number': registrationNumber,
        'capacity': capacity,
      };

  @override
  List<Object?> get props =>
      [id, imageUrl, type, model, color, registrationNumber, capacity];
}
