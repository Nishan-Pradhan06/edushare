import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class CommentThreadWidget extends StatefulWidget {
  const CommentThreadWidget({super.key});

  @override
  State<CommentThreadWidget> createState() => _CommentThreadWidgetState();
}

class _CommentThreadWidgetState extends State<CommentThreadWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  final List<Map<String, dynamic>> comments = [
    {
      "id": 1,
      "user": {
        "name": "Alex Chen",
        "avatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "isVerified": false,
      },
      "content":
          "This is exactly what I needed for my upcoming exam! The explanations are so clear and detailed. Thank you for sharing! 🙏",
      "timestamp": "2h ago",
      "likes": 12,
      "isLiked": false,
      "replies": [
        {
          "id": 11,
          "user": {
            "name": "Sarah Kim",
            "avatar":
                "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
            "isVerified": false,
          },
          "content":
              "Same here! The graph theory section is particularly helpful.",
          "timestamp": "1h ago",
          "likes": 3,
          "isLiked": false,
        }
      ]
    },
    {
      "id": 2,
      "user": {
        "name": "Dr. Michael Johnson",
        "avatar":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
        "isVerified": true,
      },
      "content":
          "Excellent work! I'd recommend also checking out the dynamic programming examples in chapter 7. They complement these notes perfectly.",
      "timestamp": "4h ago",
      "likes": 28,
      "isLiked": true,
      "replies": []
    },
    {
      "id": 3,
      "user": {
        "name": "Emma Wilson",
        "avatar":
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
        "isVerified": false,
      },
      "content":
          "Could you please add more examples for the AVL tree rotations? I'm still struggling with that concept.",
      "timestamp": "6h ago",
      "likes": 7,
      "isLiked": false,
      "replies": []
    }
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      // Add comment logic here
      _commentController.clear();
      _commentFocusNode.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comments Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'chat_bubble_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Comments (${comments.length})',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Add Comment Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Avatar
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      child: Center(
                        child: Text(
                          'U',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Comment Input
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Comment Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _commentController.clear();
                        _commentFocusNode.unfocus();
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addComment,
                      child: Text('Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Comments List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              final comment = comments[index];
              return _buildCommentItem(comment);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment Header
          Row(
            children: [
              // User Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CustomImageWidget(
                    imageUrl: (comment["user"]
                        as Map<String, dynamic>)["avatar"] as String,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (comment["user"] as Map<String, dynamic>)["name"]
                              as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if ((comment["user"]
                                as Map<String, dynamic>)["isVerified"] ==
                            true) ...[
                          SizedBox(width: 4),
                          CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      comment["timestamp"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // More Options
              IconButton(
                onPressed: () {},
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Comment Content
          Text(
            comment["content"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),

          // Comment Actions
          Row(
            children: [
              // Like Button
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: comment["isLiked"] == true
                            ? 'favorite'
                            : 'favorite_border',
                        color: comment["isLiked"] == true
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${comment["likes"]}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Reply Button
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'Reply',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Replies
          if ((comment["replies"] as List).isNotEmpty) ...[
            SizedBox(height: 12),
            Container(
              margin: EdgeInsets.only(left: 24),
              child: Column(
                children: (comment["replies"] as List)
                    .map((reply) => Container(
                          margin: EdgeInsets.only(top: 12),
                          child: _buildReplyItem(reply as Map<String, dynamic>),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(Map<String, dynamic> reply) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Avatar
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CustomImageWidget(
              imageUrl:
                  (reply["user"] as Map<String, dynamic>)["avatar"] as String,
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 8),

        // Reply Content
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      (reply["user"] as Map<String, dynamic>)["name"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      reply["timestamp"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  reply["content"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
