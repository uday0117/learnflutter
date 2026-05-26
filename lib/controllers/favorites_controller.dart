import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/constants.dart';

class FavoritesController extends GetxController {
  final _storage = GetStorage();
  final _favorites = <String>[].obs;

  List<String> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() {
    final stored = _storage.read<List>(AppConstants.favoritesKey);
    if (stored != null) {
      _favorites.value = stored.cast<String>();
    }
  }

  void _saveFavorites() {
    _storage.write(AppConstants.favoritesKey, _favorites);
  }

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  void toggleFavorite(String id) {
    if (isFavorite(id)) {
      _favorites.remove(id);
      Get.snackbar(
        'Removed',
        'Removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } else {
      _favorites.add(id);
      Get.snackbar(
        'Added',
        'Added to favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
    _saveFavorites();
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
  }
}
