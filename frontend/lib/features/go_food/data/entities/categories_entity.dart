import 'package:equatable/equatable.dart';

import '../models/category.dart';

class CategoriesEntity extends Equatable {
  final bool success;
  final String message;
  final List<Category> categories;

  const CategoriesEntity({
    required this.success,
    required this.message,
    required this.categories,
  });

  factory CategoriesEntity.fromJson(Map<String, dynamic> json) =>
      CategoriesEntity(
        success: json['success'] as bool,
        message: json['message'] as String,
        categories: (json['data'] as List<dynamic>)
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  bool? get stringify => false;

  @override
  List<Object?> get props => [success, message, categories];
}
