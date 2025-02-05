import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final int id;
  final String imageUrl;
  final int typeId;
  final int locationId;
  final String name;
  final String openingHours;
  final String phone;
  final num rating;
  final bool favoriteStats;

  const Restaurant(
      {required this.id,
      required this.imageUrl,
      required this.typeId,
      required this.locationId,
      required this.name,
      required this.openingHours,
      required this.phone,
      required this.rating,
      required this.favoriteStats});

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      typeId: json['type_id'] as int,
      locationId: json['location_id'] as int,
      name: json['name'] as String,
      openingHours: json['opening_hours'] as String,
      phone: json['phone'] as String,
      rating: json['rating'],
      favoriteStats: json['favoriteStats']);

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        typeId,
        locationId,
        name,
        openingHours,
        phone,
        rating,
        favoriteStats,
      ];

  Restaurant copyWith({
    int? id,
    String? imageUrl,
    int? typeId,
    int? locationId,
    String? name,
    String? openingHours,
    String? phone,
    num? rating,
    bool? favoriteStats,
  }) {
    return Restaurant(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      typeId: typeId ?? this.typeId,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      favoriteStats: favoriteStats ?? this.favoriteStats,
    );
  }
}
