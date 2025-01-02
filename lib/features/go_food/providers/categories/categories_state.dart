import 'package:equatable/equatable.dart';
import 'package:on_my_way/features/go_food/data/entities/categories_entity.dart';
import 'package:on_my_way/features/go_food/data/entities/items_entity.dart';

class CategoriesState extends Equatable {
  final CategoriesEntity categoriesEntity;
  final CategoryItemsEntity categoryItemsEntity;

  const CategoriesState({
    this.categoriesEntity = const CategoriesEntity(
      success: true,
      message: '',
      categories: [],
    ),
    this.categoryItemsEntity = const CategoryItemsEntity(
      success: true,
      message: '',
      products: [],
      description: '',
      id: -1,
      name: '',
    ),
  });

  CategoriesState copyWith({
    CategoriesEntity? categoriesEntity,
    CategoryItemsEntity? categoryItemsEntity,
  }) {
    return CategoriesState(
      categoriesEntity: categoriesEntity ?? this.categoriesEntity,
      categoryItemsEntity: categoryItemsEntity ?? this.categoryItemsEntity,
    );
  }

  @override
  List<Object?> get props => [categoriesEntity, categoryItemsEntity];
}
