import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterSectionWidget extends StatelessWidget {
  final Map<String, bool> selectedFaculties;
  final Map<String, bool> selectedSemesters;
  final Map<String, bool> selectedContentTypes;
  final Map<String, bool> selectedCreatorFilters;
  final Function(String, bool) onFacultyChanged;
  final Function(String, bool) onSemesterChanged;
  final Function(String, bool) onContentTypeChanged;
  final Function(String, bool) onCreatorFilterChanged;
  final VoidCallback onApplyFilters;

  const FilterSectionWidget({
    super.key,
    required this.selectedFaculties,
    required this.selectedSemesters,
    required this.selectedContentTypes,
    required this.selectedCreatorFilters,
    required this.onFacultyChanged,
    required this.onSemesterChanged,
    required this.onContentTypeChanged,
    required this.onCreatorFilterChanged,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Academic Filters
          _buildFilterCard(
            title: 'Academic',
            icon: 'school',
            children: [
              _buildFilterSubsection(
                'Faculty',
                selectedFaculties,
                onFacultyChanged,
              ),
              SizedBox(height: 12),
              _buildFilterSubsection(
                'Semester',
                selectedSemesters,
                onSemesterChanged,
              ),
            ],
          ),

          SizedBox(height: 16),

          // Content Type Filters
          _buildFilterCard(
            title: 'Content Type',
            icon: 'description',
            children: [
              _buildFilterSubsection(
                'Type',
                selectedContentTypes,
                onContentTypeChanged,
              ),
            ],
          ),

          SizedBox(height: 16),

          // Creator Filters
          _buildFilterCard(
            title: 'Creator Filters',
            icon: 'person',
            children: [
              _buildFilterSubsection(
                'Creator Type',
                selectedCreatorFilters,
                onCreatorFilterChanged,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Apply Filters Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApplyFilters,
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard({
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSubsection(
    String title,
    Map<String, bool> options,
    Function(String, bool) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.labelLarge,
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.entries.map((entry) {
            return FilterChip(
              label: Text(
                entry.key,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: entry.value
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              selected: entry.value,
              onSelected: (selected) => onChanged(entry.key, selected),
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
              checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: entry.value
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
