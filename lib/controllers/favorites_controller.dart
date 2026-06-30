import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/analytics_service.dart';

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
    final wasFavorite = favoriteIds.contains(widgetId);
    if (wasFavorite) {
      favoriteIds.remove(widgetId);
    } else {
      favoriteIds.add(widgetId);
    }
    _box.write(_key, favoriteIds.toList());
    AnalyticsService().logFavoriteToggled(
      widgetId: widgetId,
      isFavorite: !wasFavorite,
    );
  }

  bool isFavorite(String widgetId) => favoriteIds.contains(widgetId);

  int get favoritesCount => favoriteIds.length;
}
