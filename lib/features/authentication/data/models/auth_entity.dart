import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final bool success;
  final String message;
  final AuthData data;

  const AuthEntity({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthEntity.fromJson(Map<String, dynamic> json) {
    return AuthEntity(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthData.fromJson(
          json['data'] as Map<String, dynamic>), // Explicit cast
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };

  @override
  List<Object?> get props => [success, message, data];
}

class AuthData extends Equatable {
  final String token;
  final User user;
  final String type;

  const AuthData({
    required this.token,
    required this.user,
    required this.type,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      type: json['type'] ?? "client",
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user.toJson(),
        'type': type,
      };

  @override
  List<Object?> get props => [token, user, type];
}

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic ratings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.latitude,
    this.longitude,
    this.ratings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] ?? json['location']['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      ratings: json['ratings'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'ratings': ratings,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        address,
        latitude,
        longitude,
        ratings,
        createdAt,
        updatedAt,
      ];
}
