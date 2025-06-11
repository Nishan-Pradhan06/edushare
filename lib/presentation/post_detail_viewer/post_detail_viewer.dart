import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './widgets/comment_thread_widget.dart';
import './widgets/creator_profile_widget.dart';
import './widgets/document_viewer_widget.dart';
import './widgets/engagement_section_widget.dart';
import './widgets/post_header_widget.dart';
import './widgets/post_metadata_widget.dart';
import './widgets/related_content_widget.dart';

class PostDetailViewer extends StatefulWidget {
  const PostDetailViewer({super.key});

  @override
  State<PostDetailViewer> createState() => _PostDetailViewerState();
}

class _PostDetailViewerState extends State<PostDetailViewer> {
  final ScrollController _scrollController = ScrollController();
  bool _isBookmarked = false;
  bool _isLiked = false;
  bool _isFollowing = false;
  int _likeCount = 245;
  int _downloadCount = 1234;
  final int _commentCount = 18;

  // Mock post data
  final Map<String, dynamic> postData = {
    "id": 1,
    "title": "Advanced Data Structures and Algorithms - Complete Notes",
    "description":
        """Comprehensive notes covering advanced data structures including AVL trees, B-trees, graphs, and dynamic programming algorithms. These notes include detailed explanations, code examples, and practice problems to help students master complex algorithmic concepts.""",
    "creator": {
      "id": 101,
      "name": "Dr. Sarah Johnson",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "isVerified": true,
      "followerCount": 2847,
      "role": "Professor"
    },
    "subject": "Data Structures & Algorithms",
    "semester": "5th Semester",
    "faculty": "Computer Science",
    "year": "2024",
    "college": "MIT University",
    "uploadDate": "2024-01-15T10:30:00Z",
    "tags": [
      "algorithms",
      "data-structures",
      "programming",
      "computer-science"
    ],
    "fileUrl":
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
    "fileType": "PDF",
    "fileSize": "2.4 MB",
    "thumbnailUrl":
        "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop"
  };

  final List<Map<String, dynamic>> relatedPosts = [
    {
      "id": 2,
      "title": "Graph Theory Fundamentals",
      "creator": "Prof. Michael Chen",
      "subject": "Mathematics",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=200&h=150&fit=crop",
      "downloadCount": 892
    },
    {
      "id": 3,
      "title": "Dynamic Programming Solutions",
      "creator": "Dr. Sarah Johnson",
      "subject": "Computer Science",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=200&h=150&fit=crop",
      "downloadCount": 1156
    },
    {
      "id": 4,
      "title": "Algorithm Analysis Techniques",
      "creator": "Prof. David Wilson",
      "subject": "Computer Science",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=200&h=150&fit=crop",
      "downloadCount": 743
    }
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing
            ? 'Following ${postData["creator"]["name"]}'
            : 'Unfollowed ${postData["creator"]["name"]}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sharePost() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing post...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reportPost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Post'),
        content: Text('Are you sure you want to report this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post reported successfully')),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }

  void _downloadFile() {
    setState(() {
      _downloadCount++;
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download started...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            elevation: 1,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            title: Text(
              'Post Details',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            actions: [
              IconButton(
                onPressed: _toggleBookmark,
                icon: CustomIconWidget(
                  iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
                  color: _isBookmarked
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: _sharePost,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'report') {
                    _reportPost();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'flag',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text('Report Post'),
                      ],
                    ),
                  ),
                ],
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),

          // Post Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header
                PostHeaderWidget(
                  postData: postData,
                ),

                // Post Metadata
                PostMetadataWidget(
                  postData: postData,
                  downloadCount: _downloadCount,
                ),

                // Document Viewer
                DocumentViewerWidget(
                  fileUrl: postData["fileUrl"] as String,
                  fileType: postData["fileType"] as String,
                  thumbnailUrl: postData["thumbnailUrl"] as String,
                ),

                // Engagement Section
                EngagementSectionWidget(
                  isLiked: _isLiked,
                  likeCount: _likeCount,
                  commentCount: _commentCount,
                  onLikePressed: _toggleLike,
                  onDownloadPressed: _downloadFile,
                ),

                // Comment Thread
                CommentThreadWidget(),

                // Creator Profile
                CreatorProfileWidget(
                  creatorData: postData["creator"] as Map<String, dynamic>,
                  isFollowing: _isFollowing,
                  onFollowPressed: _toggleFollow,
                ),

                // Related Content
                RelatedContentWidget(
                  relatedPosts: relatedPosts,
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
