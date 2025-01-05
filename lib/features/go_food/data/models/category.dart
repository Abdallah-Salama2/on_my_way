import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String description;
  final int id;
  final int typeId;
  final String imageUrl;

  const Category({
    required this.name,
    required this.description,
    required this.id,
    required this.typeId,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
        description: json['description'],
        id: json['id'],
        typeId: json['type_id'],
        imageUrl: json['image_url']
      );

  @override
  List<Object?> get props => [name, description, id, typeId];
}
