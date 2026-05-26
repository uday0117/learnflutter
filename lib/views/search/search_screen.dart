import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart' as app;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(app.SearchController());

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search tutorials, widgets...',
            border: InputBorder.none,
          ),
          onChanged: controller.updateSearchQuery,
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              controller.addToHistory(query);
            }
          },
        ),
      ),
      body: Obx(() {
        final query = controller.searchQuery.value;

        if (query.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.searchHistory.isNotEmpty)
                      TextButton(
                        onPressed: controller.clearHistory,
                        child: const Text('Clear All'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.searchHistory.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No recent searches'),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.searchHistory.length,
                      itemBuilder: (context, index) {
                        final item = controller.searchHistory[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(item),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => controller.removeFromHistory(item),
                          ),
                          onTap: () {
                            controller.updateSearchQuery(item);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Search feature coming soon',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Full-text search across all tutorials',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
