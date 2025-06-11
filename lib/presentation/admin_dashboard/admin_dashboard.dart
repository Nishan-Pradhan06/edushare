import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';
import './widgets/admin_stats_widget.dart';
import './widgets/content_moderation_widget.dart';
import './widgets/user_management_widget.dart';

// lib/presentation/admin_dashboard/admin_dashboard.dart

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;
  List<dynamic> _users = [];
  List<dynamic> _posts = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAdminAccess();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkAdminAccess() {
    if (!_supabaseService.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/google-authentication');
      });
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final users = await _supabaseService.getUsers();
      final posts = await _supabaseService.getPosts();

      setState(() {
        _users = users;
        _posts = posts;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_supabaseService.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 64,
              ),
              SizedBox(height: 2.h),
              Text(
                'Authentication Required',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Please sign in to access admin dashboard',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/google-authentication');
                },
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_supabaseService.isAdmin) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Access Denied'),
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'block',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 64,
              ),
              SizedBox(height: 2.h),
              Text(
                'Admin Access Required',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'You do not have permission to access this area',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Demo Admin Credentials',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Email: admin@edushare.com\nPassword: admin123',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home-feed');
                    },
                    child: Text('Go Back'),
                  ),
                  SizedBox(width: 4.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/google-authentication');
                    },
                    child: Text('Sign In as Admin'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _supabaseService.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/google-authentication',
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'logout',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                size: 20,
              ),
              text: 'Overview',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'group',
                size: 20,
              ),
              text: 'Users',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'content_copy',
                size: 20,
              ),
              text: 'Content',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'error',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Error loading data',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _error,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    AdminStatsWidget(
                      users: _users,
                      posts: _posts,
                    ),
                    UserManagementWidget(
                      users: _users,
                      onUserRoleChanged: (userId, role) async {
                        try {
                          await _supabaseService.updateUserRole(userId, role);
                          _loadData();
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update user role'),
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.error,
                            ),
                          );
                        }
                      },
                    ),
                    ContentModerationWidget(
                      posts: _posts,
                      onPostDeleted: (postId) async {
                        try {
                          await _supabaseService.deletePost(postId);
                          _loadData();
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete post'),
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.error,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
    );
  }
}
