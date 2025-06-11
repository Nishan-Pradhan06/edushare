import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/applied_filters_widget.dart';
import './widgets/filter_section_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({super.key});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> recentSearches = [
    'Data Structures',
    'Machine Learning',
    'Database Management',
    'Web Development',
    'Operating Systems'
  ];

  List<String> appliedFilters = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;
  bool showFilters = false;
  String selectedSortOption = 'Relevance';

  // Filter states
  Map<String, bool> selectedFaculties = {
    'Computer Science': false,
    'Information Technology': false,
    'Electronics': false,
    'Mechanical': false,
    'Civil': false,
  };

  Map<String, bool> selectedSemesters = {
    '1st Semester': false,
    '2nd Semester': false,
    '3rd Semester': false,
    '4th Semester': false,
    '5th Semester': false,
    '6th Semester': false,
    '7th Semester': false,
    '8th Semester': false,
  };

  Map<String, bool> selectedContentTypes = {
    'Notes': false,
    'Questions': false,
    'Lab Sheets': false,
    'Assignments': false,
  };

  Map<String, bool> selectedCreatorFilters = {
    'Verified Creators': false,
    'Following': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    searchResults = [
      {
        'id': 1,
        'title': 'Data Structures and Algorithms Notes',
        'description':
            'Comprehensive notes covering arrays, linked lists, trees, and sorting algorithms with examples.',
        'creator': 'Dr. Sarah Johnson',
        'faculty': 'Computer Science',
        'semester': '3rd Semester',
        'subject': 'Data Structures',
        'contentType': 'Notes',
        'downloads': 1250,
        'rating': 4.8,
        'isVerified': true,
        'createdAt': DateTime.now().subtract(Duration(days: 2)),
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400',
        'relevanceScore': 95,
      },
      {
        'id': 2,
        'title': 'Machine Learning Lab Exercises',
        'description':
            'Practical lab exercises for ML algorithms including linear regression, decision trees, and neural networks.',
        'creator': 'Prof. Michael Chen',
        'faculty': 'Computer Science',
        'semester': '6th Semester',
        'subject': 'Machine Learning',
        'contentType': 'Lab Sheets',
        'downloads': 890,
        'rating': 4.6,
        'isVerified': true,
        'createdAt': DateTime.now().subtract(Duration(days: 5)),
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400',
        'relevanceScore': 88,
      },
      {
        'id': 3,
        'title': 'Database Management System Questions',
        'description':
            'Previous year questions and practice problems for DBMS covering SQL, normalization, and transactions.',
        'creator': 'Alex Rodriguez',
        'faculty': 'Information Technology',
        'semester': '4th Semester',
        'subject': 'Database Management',
        'contentType': 'Questions',
        'downloads': 2100,
        'rating': 4.9,
        'isVerified': false,
        'createdAt': DateTime.now().subtract(Duration(days: 1)),
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=400',
        'relevanceScore': 92,
      },
      {
        'id': 4,
        'title': 'Web Development Complete Guide',
        'description':
            'Full-stack web development notes covering HTML, CSS, JavaScript, React, and Node.js with project examples.',
        'creator': 'Emma Thompson',
        'faculty': 'Computer Science',
        'semester': '5th Semester',
        'subject': 'Web Development',
        'contentType': 'Notes',
        'downloads': 1680,
        'rating': 4.7,
        'isVerified': true,
        'createdAt': DateTime.now().subtract(Duration(days: 3)),
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=400',
        'relevanceScore': 85,
      },
    ];
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    // Simulate search delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isSearching = false;
          // Filter results based on query
          searchResults = searchResults.where((result) {
            return result['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                result['description']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                result['subject']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase());
          }).toList();
        });
      }
    });
  }

  void _addToRecentSearches(String query) {
    if (query.trim().isNotEmpty && !recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 10) {
          recentSearches.removeLast();
        }
      });
    }
  }

  void _removeRecentSearch(String search) {
    setState(() {
      recentSearches.remove(search);
    });
  }

  void _applyFilters() {
    List<String> filters = [];

    selectedFaculties.forEach((key, value) {
      if (value) filters.add(key);
    });

    selectedSemesters.forEach((key, value) {
      if (value) filters.add(key);
    });

    selectedContentTypes.forEach((key, value) {
      if (value) filters.add(key);
    });

    selectedCreatorFilters.forEach((key, value) {
      if (value) filters.add(key);
    });

    setState(() {
      appliedFilters = filters;
      showFilters = false;
    });
  }

  void _removeFilter(String filter) {
    setState(() {
      appliedFilters.remove(filter);

      // Update filter states
      selectedFaculties[filter] = false;
      selectedSemesters[filter] = false;
      selectedContentTypes[filter] = false;
      selectedCreatorFilters[filter] = false;
    });
  }

  void _clearAllFilters() {
    setState(() {
      appliedFilters.clear();
      selectedFaculties.updateAll((key, value) => false);
      selectedSemesters.updateAll((key, value) => false);
      selectedContentTypes.updateAll((key, value) => false);
      selectedCreatorFilters.updateAll((key, value) => false);
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        selectedOption: selectedSortOption,
        onOptionSelected: (option) {
          setState(() {
            selectedSortOption = option;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Search & Filter',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
            icon: CustomIconWidget(
              iconName: showFilters ? 'filter_list_off' : 'filter_list',
              color: showFilters
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _performSearch,
            onSubmitted: (query) {
              _addToRecentSearches(query);
              _performSearch(query);
            },
            isLoading: isSearching,
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Searches (show when search is empty)
                  if (_searchController.text.isEmpty &&
                      recentSearches.isNotEmpty)
                    RecentSearchesWidget(
                      searches: recentSearches,
                      onSearchTap: (search) {
                        _searchController.text = search;
                        _performSearch(search);
                      },
                      onRemove: _removeRecentSearch,
                    ),

                  // Applied Filters
                  if (appliedFilters.isNotEmpty)
                    AppliedFiltersWidget(
                      filters: appliedFilters,
                      onRemoveFilter: _removeFilter,
                      onClearAll: _clearAllFilters,
                    ),

                  // Filter Section
                  if (showFilters)
                    FilterSectionWidget(
                      selectedFaculties: selectedFaculties,
                      selectedSemesters: selectedSemesters,
                      selectedContentTypes: selectedContentTypes,
                      selectedCreatorFilters: selectedCreatorFilters,
                      onFacultyChanged: (faculty, value) {
                        setState(() {
                          selectedFaculties[faculty] = value;
                        });
                      },
                      onSemesterChanged: (semester, value) {
                        setState(() {
                          selectedSemesters[semester] = value;
                        });
                      },
                      onContentTypeChanged: (type, value) {
                        setState(() {
                          selectedContentTypes[type] = value;
                        });
                      },
                      onCreatorFilterChanged: (filter, value) {
                        setState(() {
                          selectedCreatorFilters[filter] = value;
                        });
                      },
                      onApplyFilters: _applyFilters,
                    ),

                  // Search Results
                  if (_searchController.text.isNotEmpty ||
                      appliedFilters.isNotEmpty)
                    SearchResultsWidget(
                      results: searchResults,
                      isLoading: isSearching,
                      sortOption: selectedSortOption,
                      onResultTap: (result) {
                        Navigator.pushNamed(context, '/post-detail-viewer');
                      },
                    ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
