import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';
import '../data/widgets_data.dart';
import '../models/widget_category.dart';
import '../models/widget_model.dart';
import '../services/analytics_service.dart';
import '../widgets/highlighted_text.dart';
import 'widget_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  List<WidgetModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('SearchScreen');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    if (query.trim().length >= 3) {
      AnalyticsService().logSearch(query: query.trim());
    }

    setState(() {
      _isSearching = true;
      final allWidgets = WidgetsData.getAllWidgets();
      _searchResults = allWidgets.where((widget) {
        return widget.name.toLowerCase().contains(query.toLowerCase()) ||
            widget.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: canPop,
        title: Text(
          'nav_search'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search widgets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              onChanged: _performSearch,
            ),
          ),

          // Search results
          Expanded(child: _buildSearchContent(canPop)),
        ],
      ),
    );
  }

  Widget _buildSearchContent(bool canPop) {
    final bottomOffset = canPop ? 0.0 : 60.0;

    if (!_isSearching) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomOffset),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Search for Flutter widgets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Type widget name to search',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomOffset),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'no_results'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'no_results_sub'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    final query = _searchController.text.trim();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, canPop ? 16 : 110),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final widget = _searchResults[index];
        final category = WidgetsData.getCategories().firstWhere(
          (c) => c.id == widget.categoryId,
          orElse: () => WidgetCategory(
            id: widget.categoryId,
            name: widget.categoryId.capitalizeFirst ?? widget.categoryId,
            description: '',
            icon: Icons.widgets,
            color: Theme.of(context).colorScheme.primary,
            widgetCount: 0,
          ),
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(category.icon, color: category.color),
            ),
            title: HighlightedText(
              text: widget.name,
              query: query,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                HighlightedText(
                  text: widget.description,
                  query: query,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: category.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Obx(
              () => IconButton(
                icon: Icon(
                  favoritesController.isFavorite(widget.id)
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: favoritesController.isFavorite(widget.id)
                      ? Colors.red
                      : null,
                ),
                onPressed: () {
                  favoritesController.toggleFavorite(widget.id);
                },
              ),
            ),
            onTap: () {
              Get.to(() => WidgetDetailScreen(widgetModel: widget));
            },
          ),
        );
      },
    );
  }
}
