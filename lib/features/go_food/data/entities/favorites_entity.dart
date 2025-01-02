// import 'package:equatable/equatable.dart';
// import 'package:on_my_way/features/go_food/data/models/product.dart';

// class FavoritesEntity extends Equatable {
//   final bool success;
//   final String message;
//   final List<Product> favorites;


//   const FavoritesEntity({
//     required this.success,
//     required this.message,
//     required this.favorites,
//   });

//   factory FavoritesEntity.fromJson(Map<String, dynamic> json) => FavoritesEntity(
//         success: json['success'] as bool,
//         message: json['message'] as String,
//         favorites: (json['data']['favorites'] as List<dynamic>)
//             .map((e) => Product.fromJson(e as Map<String, dynamic>))
//             .toList(),
//       );

//   @override
//   bool? get stringify => false;

//   @override
//   List<Object?> get props => [success, message, favorites];
// }
