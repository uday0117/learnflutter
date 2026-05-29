import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';
import '../data/widgets_data.dart';
import '../models/widget_category.dart';
import '../models/widget_model.dart';
import 'widget_detail_screen.dart';

class WidgetsListScreen extends StatefulWidget {
  final WidgetCategory category;

  const WidgetsListScreen({super.key, required this.category});

  @override
  State<WidgetsListScreen> createState() => _WidgetsListScreenState();
}

class _WidgetsListScreenState extends State<WidgetsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<WidgetModel> _filteredWidgets = [];

  @override
  void initState() {
    super.initState();
    _filteredWidgets = WidgetsData.getWidgetsByCategory(widget.category.id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterWidgets(String query) {
    final allWidgets = WidgetsData.getWidgetsByCategory(widget.category.id);
    setState(() {
      if (query.isEmpty) {
        _filteredWidgets = allWidgets;
      } else {
        _filteredWidgets = allWidgets.where((widget) {
          return widget.name.toLowerCase().contains(query.toLowerCase()) ||
              widget.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search in ${widget.category.name}...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterWidgets('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ),
              onChanged: _filterWidgets,
            ),
          ),

          // Widgets list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredWidgets.length,
              itemBuilder: (context, index) {
                final widget = _filteredWidgets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: this.widget.category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        this.widget.category.icon,
                        color: this.widget.category.color,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
