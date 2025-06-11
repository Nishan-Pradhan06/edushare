import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionSelected;

  const SortBottomSheetWidget({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {
        'title': 'Relevance',
        'icon': 'trending_up',
        'description': 'Best match for your search'
      },
      {
        'title': 'Most Recent',
        'icon': 'schedule',
        'description': 'Newest content first'
      },
      {
        'title': 'Most Downloaded',
        'icon': 'download',
        'description': 'Popular downloads'
      },
      {
        'title': 'Highest Rated',
        'icon': 'star',
        'description': 'Top rated content'
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                ...sortOptions.map((option) {
                  final isSelected = selectedOption == option['title'];
                  return InkWell(
                    onTap: () => onOptionSelected(option['title'] as String),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 1,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: option['icon'] as String,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option['title'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  option['description'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
