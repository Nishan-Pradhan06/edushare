import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/bookmark_card_widget.dart';
import './widgets/collection_card_widget.dart';
import './widgets/create_collection_modal.dart';

class BookmarksCollections extends StatefulWidget {
  const BookmarksCollections({super.key});

  @override
  State<BookmarksCollections> createState() => _BookmarksCollectionsState();
}

class _BookmarksCollectionsState extends State<BookmarksCollections>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditMode = false;
  final Set<int> _selectedBookmarks = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for bookmarks
  final List<Map<String, dynamic>> _bookmarks = [
    {
      "id": 1,
      "title": "Advanced Calculus Notes - Chapter 5: Integration Techniques",
      "creator": "Dr. Sarah Johnson",
      "subject": "Mathematics",
      "faculty": "Engineering",
      "semester": "3rd Semester",
      "bookmarkDate": DateTime.now().subtract(Duration(days: 2)),
      "isDownloaded": true,
      "tags": ["Calculus", "Integration", "Mathematics"],
      "thumbnail":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=400&h=300&fit=crop",
    },
    {
      "id": 2,
      "title": "Organic Chemistry Lab Manual - Synthesis Reactions",
      "creator": "Prof. Michael Chen",
      "subject": "Chemistry",
      "faculty": "Science",
      "semester": "4th Semester",
      "bookmarkDate": DateTime.now().subtract(Duration(days: 5)),
      "isDownloaded": false,
      "tags": ["Chemistry", "Lab", "Synthesis"],
      "thumbnail":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=400&h=300&fit=crop",
    },
    {
      "id": 3,
      "title": "Data Structures and Algorithms - Binary Trees",
      "creator": "Dr. Emily Rodriguez",
      "subject": "Computer Science",
      "faculty": "Engineering",
      "semester": "2nd Semester",
      "bookmarkDate": DateTime.now().subtract(Duration(days: 7)),
      "isDownloaded": true,
      "tags": ["Programming", "Algorithms", "Trees"],
      "thumbnail":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop",
    },
    {
      "id": 4,
      "title": "Physics Quantum Mechanics - Wave Functions",
      "creator": "Prof. David Kumar",
      "subject": "Physics",
      "faculty": "Science",
      "semester": "5th Semester",
      "bookmarkDate": DateTime.now().subtract(Duration(days: 10)),
      "isDownloaded": false,
      "tags": ["Physics", "Quantum", "Mechanics"],
      "thumbnail":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=300&fit=crop",
    },
    {
      "id": 5,
      "title": "Business Ethics Case Studies - Corporate Responsibility",
      "creator": "Dr. Lisa Thompson",
      "subject": "Business Studies",
      "faculty": "Management",
      "semester": "6th Semester",
      "bookmarkDate": DateTime.now().subtract(Duration(days: 12)),
      "isDownloaded": true,
      "tags": ["Business", "Ethics", "Case Studies"],
      "thumbnail":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop",
    },
  ];

  // Mock data for collections
  final List<Map<String, dynamic>> _collections = [
    {
      "id": 1,
      "name": "Mathematics Resources",
      "icon": "calculate",
      "itemCount": 12,
      "color": AppTheme.primaryLight,
      "isPrivate": false,
      "createdDate": DateTime.now().subtract(Duration(days: 30)),
    },
    {
      "id": 2,
      "name": "Lab Manuals",
      "icon": "science",
      "itemCount": 8,
      "color": AppTheme.successLight,
      "isPrivate": true,
      "createdDate": DateTime.now().subtract(Duration(days: 20)),
    },
    {
      "id": 3,
      "name": "Programming Notes",
      "icon": "code",
      "itemCount": 15,
      "color": AppTheme.accentLight,
      "isPrivate": false,
      "createdDate": DateTime.now().subtract(Duration(days: 15)),
    },
    {
      "id": 4,
      "name": "Exam Preparation",
      "icon": "quiz",
      "itemCount": 6,
      "color": AppTheme.warningLight,
      "isPrivate": true,
      "createdDate": DateTime.now().subtract(Duration(days: 10)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredBookmarks {
    if (_searchQuery.isEmpty) return _bookmarks;
    return _bookmarks.where((bookmark) {
      final title = (bookmark["title"] as String).toLowerCase();
      final creator = (bookmark["creator"] as String).toLowerCase();
      final subject = (bookmark["subject"] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) ||
          creator.contains(query) ||
          subject.contains(query);
    }).toList();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _selectedBookmarks.clear();
      }
    });
  }

  void _toggleBookmarkSelection(int bookmarkId) {
    setState(() {
      if (_selectedBookmarks.contains(bookmarkId)) {
        _selectedBookmarks.remove(bookmarkId);
      } else {
        _selectedBookmarks.add(bookmarkId);
      }
    });
  }

  void _removeSelectedBookmarks() {
    setState(() {
      _bookmarks.removeWhere(
          (bookmark) => _selectedBookmarks.contains(bookmark["id"] as int));
      _selectedBookmarks.clear();
      _isEditMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmarks removed successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _showCreateCollectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateCollectionModal(
        onCollectionCreated: (collectionData) {
          setState(() {
            _collections.add({
              "id": _collections.length + 1,
              "name": collectionData["name"],
              "icon": collectionData["icon"],
              "itemCount": 0,
              "color": collectionData["color"],
              "isPrivate": collectionData["isPrivate"],
              "createdDate": DateTime.now(),
            });
          });
        },
      ),
    );
  }

  void _showBookmarkContextMenu(Map<String, dynamic> bookmark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
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
            SizedBox(height: 20),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'folder_copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Move to Collection'),
              onTap: () {
                Navigator.pop(context);
                // Handle move to collection
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_remove',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text('Remove Bookmark'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _bookmarks.removeWhere((b) => b["id"] == bookmark["id"]);
                });
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName:
                    bookmark["isDownloaded"] ? 'download_done' : 'download',
                color: bookmark["isDownloaded"]
                    ? AppTheme.successLight
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(bookmark["isDownloaded"]
                  ? 'Downloaded'
                  : 'Download for Offline'),
              onTap: () {
                Navigator.pop(context);
                if (!bookmark["isDownloaded"]) {
                  setState(() {
                    bookmark["isDownloaded"] = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Bookmarks & Collections',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          if (_tabController.index == 0)
            TextButton(
              onPressed: _toggleEditMode,
              child: Text(
                _isEditMode ? 'Done' : 'Edit',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search bookmarks...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(2),
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: [
                    Tab(text: 'All Bookmarks'),
                    Tab(text: 'Collections'),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Bookmarks Tab
          _buildBookmarksView(),
          // Collections Tab
          _buildCollectionsView(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _showCreateCollectionModal,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
              label: Text('Create Collection'),
            )
          : null,
    );
  }

  Widget _buildBookmarksView() {
    if (_filteredBookmarks.isEmpty) {
      return _buildEmptyBookmarksState();
    }

    return Column(
      children: [
        if (_isEditMode && _selectedBookmarks.isNotEmpty)
          Container(
            padding: EdgeInsets.all(16),
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            child: Row(
              children: [
                Text(
                  '${_selectedBookmarks.length} selected',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: _removeSelectedBookmarks,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.errorLight,
                    size: 20,
                  ),
                  label: Text(
                    'Remove',
                    style: TextStyle(color: AppTheme.errorLight),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            itemCount: _filteredBookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = _filteredBookmarks[index];
              return BookmarkCardWidget(
                bookmark: bookmark,
                isEditMode: _isEditMode,
                isSelected: _selectedBookmarks.contains(bookmark["id"] as int),
                onTap: () {
                  if (_isEditMode) {
                    _toggleBookmarkSelection(bookmark["id"] as int);
                  } else {
                    Navigator.pushNamed(context, '/post-detail-viewer');
                  }
                },
                onLongPress: () {
                  if (!_isEditMode) {
                    _showBookmarkContextMenu(bookmark);
                  }
                },
                onSwipeLeft: () {
                  setState(() {
                    _bookmarks.removeWhere((b) => b["id"] == bookmark["id"]);
                  });
                },
                onSwipeRight: () {
                  // Add to collection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Add to collection feature'),
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionsView() {
    if (_collections.isEmpty) {
      return _buildEmptyCollectionsState();
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _collections.length,
      itemBuilder: (context, index) {
        final collection = _collections[index];
        return CollectionCardWidget(
          collection: collection,
          onTap: () {
            // Navigate to collection detail
            Navigator.pushNamed(context, '/bookmarks-collections');
          },
        );
      },
    );
  }

  Widget _buildEmptyBookmarksState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'bookmark_border',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 24),
            Text(
              'No Bookmarks Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Save educational resources to access them quickly later. Bookmark posts, notes, and materials you find useful.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home-feed');
              },
              child: Text('Explore Content'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCollectionsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'folder_open',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 24),
            Text(
              'No Collections Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Organize your bookmarks into collections for better management. Create folders for different subjects or topics.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showCreateCollectionModal,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Create Collection'),
            ),
          ],
        ),
      ),
    );
  }
}
