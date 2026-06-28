import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoritesController extends GetxController {
  static const _key = 'favorite_ids';
  final _box = GetStorage();

  var favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<List>(_key) ?? [];
    favoriteIds.addAll(saved.map((e) => e.toString()));
  }

  void toggleFavorite(String widgetId) {
    if (favoriteIds.contains(widgetId)) {
      favoriteIds.remove(widgetId);
    } else {
      favoriteIds.add(widgetId);
    }
    _box.write(_key, favoriteIds.toList());
  }

  bool isFavorite(String widgetId) => favoriteIds.contains(widgetId);

  int get favoritesCount => favoriteIds.length;
}
