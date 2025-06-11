import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> searches;
  final Function(String) onSearchTap;
  final Function(String) onRemove;

  const RecentSearchesWidget({
    super.key,
    required this.searches,
    required this.onSearchTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // Clear all recent searches
                  for (String search in List.from(searches)) {
                    onRemove(search);
                  }
                },
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searches.map((search) {
              return GestureDetector(
                onTap: () => onSearchTap(search),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'history',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        search,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onRemove(search),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
