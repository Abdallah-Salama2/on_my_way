import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String description;
  final int id;
  final int typeId;

  const Category({
    required this.name,
    this.description = "",
    this.id = 0,
    this.typeId = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
        description: json['description'],
        id: json['id'],
        typeId: json['type_id'],
      );

  @override
  List<Object?> get props => [name, description, id, typeId];
}
