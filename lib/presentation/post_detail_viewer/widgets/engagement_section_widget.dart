import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_export.dart';

class EngagementSectionWidget extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final VoidCallback onLikePressed;
  final VoidCallback onDownloadPressed;

  const EngagementSectionWidget({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.onLikePressed,
    required this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        // borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Engagement Stats
          Row(
            children: [
              // Like Count
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'favorite',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '$likeCount',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),

              // Comment Count
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'chat_bubble_outline',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '$commentCount',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Spacer(),

              // View Count
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'visibility',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '2.1k views',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              // Like Button
              Expanded(
                child: _buildActionButton(
                  icon: isLiked ? 'favorite' : 'favorite_border',
                  label: 'Like',
                  color: isLiked
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  onPressed: onLikePressed,
                ),
              ),
              SizedBox(width: 12),

              // Comment Button
              Expanded(
                child: _buildActionButton(
                  icon: 'chat_bubble_outline',
                  label: 'Comment',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Scroll to comments section
                  },
                ),
              ),
              SizedBox(width: 12),

              // Download Button
              Expanded(
                child: _buildActionButton(
                  icon: 'download',
                  label: 'Download',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onPressed: onDownloadPressed,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary
          ? AppTheme.lightTheme.colorScheme.primary
          : AppTheme.lightTheme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isPrimary
                ? null
                : Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: isPrimary
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : color,
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isPrimary
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
