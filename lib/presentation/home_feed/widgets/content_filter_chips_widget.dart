import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ContentFilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
  final Function(String) onFilterSelected;

  const ContentFilterChipsWidget({
    super.key,
    required this.filters,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = filter["isActive"] as bool;

          return FilterChip(
            label: Text(
              filter["label"] as String,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isActive
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            selected: isActive,
            onSelected: (selected) {
              onFilterSelected(filter["label"] as String);
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedColor: AppTheme.lightTheme.colorScheme.primary,
            checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
            side: BorderSide(
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
