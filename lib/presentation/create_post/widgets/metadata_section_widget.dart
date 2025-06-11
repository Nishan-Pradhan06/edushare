import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MetadataSectionWidget extends StatelessWidget {
  final List<String> subjects;
  final List<String> semesters;
  final List<String> faculties;
  final List<String> years;
  final List<String> categories;
  final String? selectedSubject;
  final String? selectedSemester;
  final String? selectedFaculty;
  final String? selectedYear;
  final String? selectedCategory;
  final Function(String?) onSubjectChanged;
  final Function(String?) onSemesterChanged;
  final Function(String?) onFacultyChanged;
  final Function(String?) onYearChanged;
  final Function(String?) onCategoryChanged;

  const MetadataSectionWidget({
    super.key,
    required this.subjects,
    required this.semesters,
    required this.faculties,
    required this.years,
    required this.categories,
    required this.selectedSubject,
    required this.selectedSemester,
    required this.selectedFaculty,
    required this.selectedYear,
    required this.selectedCategory,
    required this.onSubjectChanged,
    required this.onSemesterChanged,
    required this.onFacultyChanged,
    required this.onYearChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      color: ColorScheme.of(context).onPrimary,
      shadowColor: AppTheme.shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metadata & Classification',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),

            // Subject Dropdown
            _buildDropdownField(
              label: 'Subject *',
              value: selectedSubject,
              items: subjects,
              onChanged: onSubjectChanged,
              hint: 'Select subject',
            ),

            SizedBox(height: 16),

            // Semester and Faculty Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Semester *',
                    value: selectedSemester,
                    items: semesters,
                    onChanged: onSemesterChanged,
                    hint: 'Select semester',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Faculty *',
                    value: selectedFaculty,
                    items: faculties,
                    onChanged: onFacultyChanged,
                    hint: 'Select faculty',
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Year and Category Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Academic Year',
                    value: selectedYear,
                    items: years,
                    onChanged: onYearChanged,
                    hint: 'Select year',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Category *',
                    value: selectedCategory,
                    items: categories,
                    onChanged: onCategoryChanged,
                    hint: 'Select category',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: label.contains('*')
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          isExpanded: true,
        ),
      ],
    );
  }
}
