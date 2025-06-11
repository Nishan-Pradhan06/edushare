import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/admin_dashboard/widgets/content_moderation_widget.dart

class ContentModerationWidget extends StatefulWidget {
  final List<dynamic> posts;
  final Function(String postId) onPostDeleted;

  const ContentModerationWidget({
    super.key,
    required this.posts,
    required this.onPostDeleted,
  });

  @override
  State<ContentModerationWidget> createState() =>
      _ContentModerationWidgetState();
}

class _ContentModerationWidgetState extends State<ContentModerationWidget> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';
  final List<String> _statusFilters = [
    'All',
    'Published',
    'Pending',
    'Reported'
  ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredPosts = widget.posts.where((post) {
      bool matchesSearch = _searchQuery.isEmpty ||
          (post['title'] ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (post['content'] ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      bool matchesStatus = _selectedStatusFilter == 'All' ||
          (post['status'] ?? 'Published') ==
              _selectedStatusFilter.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();

    return Column(children: [
      // Search and Filter Header
      Container(
          padding: EdgeInsets.all(4.w),
          child: Column(children: [
            // Search Bar
            TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Search posts by title or content...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: AppTheme.lightTheme.colorScheme.surface)),
            SizedBox(height: 2.h),

            // Status Filter
            Row(children: [
              Text('Filter by Status:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(width: 3.w),
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _statusFilters.map((status) {
                        bool isSelected = _selectedStatusFilter == status;
                        return Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: FilterChip(
                                label: Text(status),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedStatusFilter = status;
                                  });
                                },
                                selectedColor: AppTheme
                                    .lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                                checkmarkColor:
                                    AppTheme.lightTheme.colorScheme.primary));
                      }).toList()))),
            ]),
          ])),

      // Posts List
      Expanded(
          child: filteredPosts.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      CustomIconWidget(
                          iconName: 'content_copy_off',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48),
                      SizedBox(height: 2.h),
                      Text('No posts found',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                      SizedBox(height: 1.h),
                      Text('Try adjusting your search or filter criteria',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                    ]))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    final post = filteredPosts[index];
                    return _buildPostCard(post);
                  })),
    ]);
  }

  Widget _buildPostCard(dynamic post) {
    String title = post['title'] ?? 'Untitled Post';
    String content = post['content'] ?? 'No content';
    String status = post['status'] ?? 'published';
    String authorName = post['profiles']?['full_name'] ?? 'Unknown Author';
    String createdAt = post['created_at'] ?? '';
    int likesCount = post['likes_count'] ?? 0;
    int commentsCount = post['comments_count'] ?? 0;

    return Container(
        margin: EdgeInsets.only(bottom: 3.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _getStatusColor(status).withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 0.5.h),
                  Row(children: [
                    Text('By $authorName',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant)),
                    SizedBox(width: 2.w),
                    _buildStatusBadge(status),
                  ]),
                ])),
            PopupMenuButton<String>(
                icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20),
                onSelected: (value) {
                  if (value == 'view') {
                    _showPostDetails(post);
                  } else if (value == 'delete') {
                    _showDeleteDialog(post);
                  } else if (value == 'approve') {
                    _approvePost(post);
                  } else if (value == 'reject') {
                    _rejectPost(post);
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'view',
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'visibility',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 16),
                            SizedBox(width: 2.w),
                            Text('View Details'),
                          ])),
                      if (status == 'pending') ...[
                        PopupMenuItem(
                            value: 'approve',
                            child: Row(children: [
                              CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: Colors.green,
                                  size: 16),
                              SizedBox(width: 2.w),
                              Text('Approve'),
                            ])),
                        PopupMenuItem(
                            value: 'reject',
                            child: Row(children: [
                              CustomIconWidget(
                                  iconName: 'cancel',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 16),
                              SizedBox(width: 2.w),
                              Text('Reject'),
                            ])),
                      ],
                      PopupMenuDivider(),
                      PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'delete',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 16),
                            SizedBox(width: 2.w),
                            Text('Delete',
                                style: TextStyle(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error)),
                          ])),
                    ]),
          ]),

          SizedBox(height: 2.h),

          // Content Preview
          Text(content,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),

          SizedBox(height: 2.h),

          // Metrics
          Row(children: [
            _buildMetric('favorite', likesCount.toString(), 'Likes'),
            SizedBox(width: 4.w),
            _buildMetric('comment', commentsCount.toString(), 'Comments'),
            Spacer(),
            if (createdAt.isNotEmpty)
              Text(_formatDate(createdAt),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          ]),
        ]));
  }

  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Text(status.toUpperCase(),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color, fontWeight: FontWeight.w600, fontSize: 10)));
  }

  Widget _buildMetric(String iconName, String value, String label) {
    return Row(children: [
      CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16),
      SizedBox(width: 1.w),
      Text(value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600)),
    ]);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'reported':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      Duration difference = DateTime.now().difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showPostDetails(dynamic post) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Post Details'),
                content: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildDetailRow('Title', post['title'] ?? 'No title'),
                      _buildDetailRow('Author',
                          post['profiles']?['full_name'] ?? 'Unknown'),
                      _buildDetailRow('Status', post['status'] ?? 'published'),
                      _buildDetailRow(
                          'Created', post['created_at'] ?? 'Unknown'),
                      _buildDetailRow(
                          'Likes', (post['likes_count'] ?? 0).toString()),
                      _buildDetailRow(
                          'Comments', (post['comments_count'] ?? 0).toString()),
                      SizedBox(height: 2.h),
                      Text('Content:',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 1.h),
                      Text(post['content'] ?? 'No content',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                    ])),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close')),
                ]));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 20.w,
              child: Text('$label:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600))),
          Expanded(
              child:
                  Text(value, style: AppTheme.lightTheme.textTheme.bodyMedium)),
        ]));
  }

  void _showDeleteDialog(dynamic post) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Delete Post'),
                content: Text(
                    'Are you sure you want to delete "${post['title']}"? This action cannot be undone.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onPostDeleted(post['id']);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.error,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onError),
                      child: Text('Delete')),
                ]));
  }

  void _approvePost(dynamic post) {
    // Implementation for approving post
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post "${post['title']}" approved'),
        backgroundColor: Colors.green));
  }

  void _rejectPost(dynamic post) {
    // Implementation for rejecting post
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post "${post['title']}" rejected'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error));
  }
}
