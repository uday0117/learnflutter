import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/app_models.dart';
import '../../core/services/data_service.dart';
import 'widget_detail_screen.dart';

class WidgetReferenceScreen extends StatelessWidget {
  const WidgetReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final widgets = AppData.getWidgetReferences();
    
    // Group widgets by category
    final Map<String, List<WidgetReference>> groupedWidgets = {};
    for (var widget in widgets) {
      if (!groupedWidgets.containsKey(widget.category)) {
        groupedWidgets[widget.category] = [];
      }
      groupedWidgets[widget.category]!.add(widget);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('🧩 Widget Reference')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: groupedWidgets.length,
        itemBuilder: (context, index) {
          final category = groupedWidgets.keys.elementAt(index);
          final categoryWidgets = groupedWidgets[category]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 16, bottom: 12),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                ),
              ),
              ...categoryWidgets.map((widget) => _WidgetCard(widget: widget)),
            ],
          );
        },
      ),
    );
  }
}

class _WidgetCard extends StatelessWidget {
  final WidgetReference widget;

  const _WidgetCard({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => WidgetDetailScreen(widget: widget));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Preview thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: widget.previewBuilder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Widget info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
