import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/content_filter_chips_widget.dart';
import './widgets/educational_post_card_widget.dart';
import './widgets/skeleton_card_widget.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicator = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  bool _isLoading = false;
  bool _hasMoreContent = true;
  int _currentBottomNavIndex = 0;
  String _selectedFilter = 'All';

  // Mock data for educational posts
  final List<Map<String, dynamic>> _posts = [
    {
      "id": 1,
      "creatorName": "Dr. Sarah Johnson",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "title": "Advanced Data Structures and Algorithms",
      "description":
          "Comprehensive notes covering binary trees, graph algorithms, and dynamic programming with practical examples.",
      "subject": "Computer Science",
      "faculty": "Engineering",
      "semester": "5th",
      "contentType": "Notes",
      "likes": 245,
      "comments": 32,
      "downloads": 156,
      "isBookmarked": false,
      "isTrending": true,
      "isNew": false,
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300&h=200&fit=crop",
      "uploadTime": "2 hours ago",
      "fileSize": "2.4 MB",
      "tags": ["Algorithms", "Data Structures", "Programming"]
    },
    {
      "id": 2,
      "creatorName": "Prof. Michael Chen",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "title": "Organic Chemistry Lab Manual",
      "description":
          "Complete lab procedures for organic synthesis reactions with safety protocols and expected results.",
      "subject": "Chemistry",
      "faculty": "Science",
      "semester": "3rd",
      "contentType": "Lab Sheet",
      "likes": 189,
      "comments": 28,
      "downloads": 203,
      "isBookmarked": true,
      "isTrending": false,
      "isNew": true,
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=300&h=200&fit=crop",
      "uploadTime": "1 day ago",
      "fileSize": "3.1 MB",
      "tags": ["Organic Chemistry", "Lab", "Synthesis"]
    },
    {
      "id": 3,
      "creatorName": "Dr. Emily Rodriguez",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "title": "Calculus II Practice Problems",
      "description":
          "Challenging integration problems with step-by-step solutions for exam preparation.",
      "subject": "Mathematics",
      "faculty": "Science",
      "semester": "2nd",
      "contentType": "Questions",
      "likes": 312,
      "comments": 45,
      "downloads": 278,
      "isBookmarked": false,
      "isTrending": true,
      "isNew": false,
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=300&h=200&fit=crop",
      "uploadTime": "3 days ago",
      "fileSize": "1.8 MB",
      "tags": ["Calculus", "Integration", "Practice"]
    },
    {
      "id": 4,
      "creatorName": "Prof. David Kim",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "title": "Physics Mechanics Study Guide",
      "description":
          "Comprehensive review of classical mechanics including Newton's laws, energy, and momentum.",
      "subject": "Physics",
      "faculty": "Science",
      "semester": "1st",
      "contentType": "Notes",
      "likes": 167,
      "comments": 19,
      "downloads": 134,
      "isBookmarked": false,
      "isTrending": false,
      "isNew": true,
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=300&h=200&fit=crop",
      "uploadTime": "5 hours ago",
      "fileSize": "2.7 MB",
      "tags": ["Physics", "Mechanics", "Classical"]
    },
    {
      "id": 5,
      "creatorName": "Dr. Lisa Wang",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
      "title": "Database Design Fundamentals",
      "description":
          "Entity-relationship modeling, normalization techniques, and SQL query optimization strategies.",
      "subject": "Database Systems",
      "faculty": "Engineering",
      "semester": "4th",
      "contentType": "Notes",
      "likes": 298,
      "comments": 37,
      "downloads": 221,
      "isBookmarked": true,
      "isTrending": true,
      "isNew": false,
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=300&h=200&fit=crop",
      "uploadTime": "1 week ago",
      "fileSize": "4.2 MB",
      "tags": ["Database", "SQL", "Design"]
    }
  ];

  final List<Map<String, dynamic>> _filterChips = [
    {"label": "All", "isActive": true},
    {"label": "Engineering", "isActive": false},
    {"label": "Science", "isActive": false},
    {"label": "Notes", "isActive": false},
    {"label": "Questions", "isActive": false},
    {"label": "Lab Sheets", "isActive": false},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreContent) {
        _loadMoreContent();
      }
    }
  }

  Future<void> _loadMoreContent() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      // Simulate no more content after some scrolling
      if (_posts.length > 10) {
        _hasMoreContent = false;
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Reset content
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      // Update filter chips
      for (var chip in _filterChips) {
        chip["isActive"] = chip["label"] == filter;
      }
    });
  }

  void _onPostTap(Map<String, dynamic> post) {
    Navigator.pushNamed(context, '/post-detail-viewer', arguments: post);
  }

  void _onPostLongPress(Map<String, dynamic> post) {
    HapticFeedback.mediumImpact();
    _showQuickActions(post);
  }

  void _onBookmarkTap(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    setState(() {
      post["isBookmarked"] = !post["isBookmarked"];
    });
  }

  void _showQuickActions(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CustomIconWidget(
                iconName: post["isBookmarked"] ? 'bookmark' : 'bookmark_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                post["isBookmarked"] ? 'Remove Bookmark' : 'Bookmark',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _onBookmarkTap(post);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Share',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text(
                'Report',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.errorLight,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/search-filter');
        break;
      case 2:
        Navigator.pushNamed(context, '/bookmarks-collections');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ContentFilterChipsWidget(
                filters: _filterChips,
                onFilterSelected: _onFilterSelected,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _posts.length) {
                      return EducationalPostCardWidget(
                        post: _posts[index],
                        onTap: () => _onPostTap(_posts[index]),
                        onLongPress: () => _onPostLongPress(_posts[index]),
                        onBookmarkTap: () => _onBookmarkTap(_posts[index]),
                      );
                    } else if (_isLoading) {
                      return const SkeletonCardWidget();
                    } else if (!_hasMoreContent) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'school',
                              color: AppTheme.lightTheme.colorScheme.outline,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'You\'ve reached the end!',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back later for new content',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  childCount: _posts.length + (_isLoading ? 3 : 1),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      shadowColor: AppTheme.shadowLight,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'school',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'EduShare',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                // Handle notifications
              },
              icon: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.errorLight,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/create-post');
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
      elevation: 4,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onTertiary,
        size: 24,
      ),
    );
  }
}
