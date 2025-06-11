import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'school',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 60,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // App name
        Text(
          'EduShare',
          style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        // App tagline
        Text(
          'Share Knowledge, Shape Future',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
