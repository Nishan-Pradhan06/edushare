import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress;

  const UploadProgressWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'cloud_upload',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 40,
                ),
              ),
            ),

            SizedBox(height: 24),

            // Progress Title
            Text(
              'Publishing Your Post',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 8),

            // Progress Description
            Text(
              'Please wait while we upload your files and publish your post...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32),

            // Progress Bar
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upload Progress',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Upload Steps
            _buildUploadSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSteps() {
    final steps = [
      {'title': 'Validating files', 'completed': progress > 0.2},
      {'title': 'Uploading content', 'completed': progress > 0.5},
      {'title': 'Processing metadata', 'completed': progress > 0.8},
      {'title': 'Publishing post', 'completed': progress >= 1.0},
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = step['completed'] as bool;
        final isActive = !isCompleted &&
            (index == 0 || (steps[index - 1]['completed'] as bool));

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Step Icon
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successLight
                      : isActive
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 16,
                        )
                      : isActive
                          ? SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Container(),
                ),
              ),

              SizedBox(width: 12),

              // Step Title
              Text(
                step['title'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isCompleted || isActive
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
