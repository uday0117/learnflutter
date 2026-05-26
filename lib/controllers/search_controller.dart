import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/constants.dart';

class SearchController extends GetxController {
  final searchQuery = ''.obs;
  final searchHistory = <String>[].obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
  }

  void _loadSearchHistory() {
    final stored = _storage.read<List>(AppConstants.searchHistoryKey);
    if (stored != null) {
      searchHistory.value = stored.cast<String>();
    }
  }

  void _saveSearchHistory() {
    _storage.write(
      AppConstants.searchHistoryKey,
      searchHistory.take(10).toList(),
    );
  }

  void addToHistory(String query) {
    if (query.isNotEmpty && !searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      _saveSearchHistory();
    }
  }

  void removeFromHistory(String query) {
    searchHistory.remove(query);
    _saveSearchHistory();
  }

  void clearHistory() {
    searchHistory.clear();
    _saveSearchHistory();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
