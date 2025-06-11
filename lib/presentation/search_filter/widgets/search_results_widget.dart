import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final bool isLoading;
  final String sortOption;
  final Function(Map<String, dynamic>) onResultTap;

  const SearchResultsWidget({
    super.key,
    required this.results,
    required this.isLoading,
    required this.sortOption,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Searching...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (results.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'search_off',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No results found',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your search terms or filters',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${results.length} results found',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                Text(
                  'Sorted by $sortOption',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _buildResultCard(context, result);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> result) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onResultTap(result),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: result['thumbnailUrl'] ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                result['title'] ?? '',
                                style:
                                    AppTheme.lightTheme.textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (result['isVerified'] == true)
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'verified',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 12,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          result['description'] ?? '',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'person',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              result['creator'] ?? '',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Metadata chips
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildMetadataChip(result['faculty'] ?? '', 'school'),
                  _buildMetadataChip(
                      result['semester'] ?? '', 'calendar_today'),
                  _buildMetadataChip(
                      result['contentType'] ?? '', 'description'),
                ],
              ),

              SizedBox(height: 12),

              // Stats and relevance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'download',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${result['downloads']}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(width: 16),
                      CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${result['rating']}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${result['relevanceScore']}% match',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(String label, String iconName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
