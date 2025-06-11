import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoleManagementWidget extends StatelessWidget {
  final String applicationStatus;
  final VoidCallback onBecomeCreator;

  const RoleManagementWidget({
    super.key,
    required this.applicationStatus,
    required this.onBecomeCreator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        // borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
          width: 1,
        ),
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
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Become a Creator',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            'Share your knowledge and help fellow students by becoming a content creator. Upload notes, questions, and educational resources.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          SizedBox(height: 2.h),

          // Requirements
          _buildRequirement('Upload quality educational content'),
          _buildRequirement('Follow community guidelines'),
          _buildRequirement('Maintain active participation'),

          SizedBox(height: 3.h),

          // Action Button based on status
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    switch (applicationStatus) {
      case 'pending':
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 3.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'hourglass_empty',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                'Application Pending',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Your application is under review',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );

      case 'approved':
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 3.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                'Application Approved!',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'You can now start creating content',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );

      case 'rejected':
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'cancel',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Application Rejected',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'You can reapply after 30 days',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBecomeCreator,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
                ),
                child: Text('Reapply'),
              ),
            ),
          ],
        );

      default: // not_applied
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onBecomeCreator,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            icon: CustomIconWidget(
              iconName: 'star',
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              size: 20,
            ),
            label: Text(
              'Apply to Become Creator',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
    }
  }
}
