import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemsRepoProvider = Provider.autoDispose(
  (ref) => ItemsRepo(ref),
  name: "Items Repo Provider",
);

class ItemsRepo {
  final Ref ref;

  ItemsRepo(this.ref);

  Future getItems({
    required int type,
  }) async {}

  Future showSingleItem({
    required int id,
  }) async {}
}
