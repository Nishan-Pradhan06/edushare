import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingStepWidget extends StatelessWidget {
  const OnboardingStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),

          // Illustration
          Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'school',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 80,
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // Welcome text
          Text(
            'Welcome to EduShare',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Subtitle
          Text(
            'Share, Discover, Learn',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Description
          Text(
            'Connect with students and educators to share educational resources, discover new materials, and enhance your learning experience.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          // Features list
          _buildFeatureItem(
            context,
            'share',
            'Share Resources',
            'Upload and share your notes, assignments, and study materials',
          ),

          SizedBox(height: 3.h),

          _buildFeatureItem(
            context,
            'search',
            'Discover Content',
            'Find resources by subject, semester, and faculty',
          ),

          SizedBox(height: 3.h),

          _buildFeatureItem(
            context,
            'people',
            'Connect & Learn',
            'Follow creators and engage with the academic community',
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, String iconName, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
