import 'package:on_my_way/features/go_food/data/models/favorites_entity.dart';

class FavoritesState {
  final FavoritesEntity favoritesEntity;

  const FavoritesState({required this.favoritesEntity});

  FavoritesState copyWith({FavoritesEntity? favoritesEntity}) {
    return FavoritesState(
      favoritesEntity: favoritesEntity ?? this.favoritesEntity,
    );
  }
}