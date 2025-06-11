import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AcademicInfoWidget extends StatelessWidget {
  final List<Map<String, dynamic>> colleges;
  final List<Map<String, dynamic>> faculties;
  final List<Map<String, dynamic>> years;
  final List<Map<String, dynamic>> batches;
  final String selectedCollege;
  final String selectedFaculty;
  final String selectedYear;
  final String selectedBatch;
  final Function(String) onCollegeChanged;
  final Function(String) onFacultyChanged;
  final Function(String) onYearChanged;
  final Function(String) onBatchChanged;

  const AcademicInfoWidget({
    super.key,
    required this.colleges,
    required this.faculties,
    required this.years,
    required this.batches,
    required this.selectedCollege,
    required this.selectedFaculty,
    required this.selectedYear,
    required this.selectedBatch,
    required this.onCollegeChanged,
    required this.onFacultyChanged,
    required this.onYearChanged,
    required this.onBatchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),

          // Title
          Text(
            'Academic Information',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            'Help us personalize your experience by providing your academic details',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          // College/University dropdown
          _buildDropdownField(
            context,
            label: 'College/University',
            value: selectedCollege,
            items: colleges,
            onChanged: onCollegeChanged,
            icon: 'school',
          ),

          SizedBox(height: 3.h),

          // Faculty dropdown
          _buildDropdownField(
            context,
            label: 'Faculty',
            value: selectedFaculty,
            items: faculties,
            onChanged: onFacultyChanged,
            icon: 'book',
          ),

          SizedBox(height: 3.h),

          // Year dropdown
          _buildDropdownField(
            context,
            label: 'Current Year',
            value: selectedYear,
            items: years,
            onChanged: onYearChanged,
            icon: 'calendar_today',
          ),

          SizedBox(height: 3.h),

          // Batch dropdown
          _buildDropdownField(
            context,
            label: 'Batch',
            value: selectedBatch,
            items: batches,
            onChanged: onBatchChanged,
            icon: 'group',
          ),

          SizedBox(height: 6.h),

          // Info card
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why do we need this?',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'This information helps us show you relevant resources and connect you with peers from your academic background.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required String value,
    required List<Map<String, dynamic>> items,
    required Function(String) onChanged,
    required String icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value.isEmpty
                  ? AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3)
                  : AppTheme.lightTheme.colorScheme.primary,
              width: value.isEmpty ? 1 : 2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: Row(
                children: [
                  CustomIconWidget(
                    iconName: icon,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Select $label',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                size: 24,
              ),
              isExpanded: true,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              dropdownColor: AppTheme.lightTheme.colorScheme.surface,
              items: items.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item["name"] as String,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: icon,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          item["name"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
