import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class PostHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> postData;

  const PostHeaderWidget({
    super.key,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Title
          Text(
            postData["title"] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12),

          // Creator Info Row
          Row(
            children: [
              // Creator Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomImageWidget(
                    imageUrl: (postData["creator"]
                        as Map<String, dynamic>)["avatar"] as String,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Creator Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (postData["creator"] as Map<String, dynamic>)["name"]
                              as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if ((postData["creator"]
                                as Map<String, dynamic>)["isVerified"] ==
                            true) ...[
                          SizedBox(width: 4),
                          CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      (postData["creator"] as Map<String, dynamic>)["role"]
                          as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Upload Date
              Text(
                _formatDate(postData["uploadDate"] as String),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Post Description
          Text(
            postData["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
