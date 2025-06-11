import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AcademicInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEdit;

  const AcademicInfoCardWidget({
    super.key,
    required this.userData,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        // borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Academic Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Academic Info Grid
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: 'school',
                      label: 'College',
                      value: userData["college"] ?? "Not specified",
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildInfoItem(
                      icon: 'book',
                      label: 'Faculty',
                      value: userData["faculty"] ?? "Not specified",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: 'calendar_today',
                      label: 'Semester',
                      value: userData["semester"] ?? "Not specified",
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildInfoItem(
                      icon: 'group',
                      label: 'Batch',
                      value: userData["batch"] ?? "Not specified",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
