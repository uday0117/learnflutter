import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoritesController extends GetxController {
  final _storage = GetStorage();
  static const String _favoritesKey = 'favorite_topics';

  final RxSet<String> _favoriteTopicIds = <String>{}.obs;

  Set<String> get favoriteTopicIds => _favoriteTopicIds;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<dynamic>? stored = _storage.read<List<dynamic>>(_favoritesKey);
    if (stored != null) {
      _favoriteTopicIds.value = stored.cast<String>().toSet();
    }
  }

  void _saveFavorites() {
    _storage.write(_favoritesKey, _favoriteTopicIds.toList());
  }

  bool isFavorite(String topicId) {
    return _favoriteTopicIds.contains(topicId);
  }

  void toggleFavorite(String topicId) {
    if (_favoriteTopicIds.contains(topicId)) {
      _favoriteTopicIds.remove(topicId);
      Get.snackbar(
        'Removed',
        'Removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } else {
      _favoriteTopicIds.add(topicId);
      Get.snackbar(
        'Added',
        'Added to favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
    _saveFavorites();
  }

  int get favoritesCount => _favoriteTopicIds.length;
}
