import 'package:get/get.dart';

class FavoritesController extends GetxController {
  // Observable set of favorite widget IDs
  var favoriteIds = <String>{}.obs;

  // Toggle favorite status
  void toggleFavorite(String widgetId) {
    if (favoriteIds.contains(widgetId)) {
      favoriteIds.remove(widgetId);
    } else {
      favoriteIds.add(widgetId);
    }
  }

  // Check if widget is favorite
  bool isFavorite(String widgetId) {
    return favoriteIds.contains(widgetId);
  }

  // Get count of favorites
  int get favoritesCount => favoriteIds.length;
}
