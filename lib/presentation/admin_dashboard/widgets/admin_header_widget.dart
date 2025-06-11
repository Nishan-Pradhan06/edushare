import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/supabase_service.dart';

// lib/presentation/admin_dashboard/widgets/admin_header_widget.dart

class AdminHeaderWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const AdminHeaderWidget({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();
    final user = supabaseService.currentUser;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 8.w,
                  backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  child: CustomIconWidget(
                    iconName: 'admin_panel_settings',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 32,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Admin',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        user?.email ?? 'admin@edushare.com',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRefresh,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _handleLogout(context);
                    } else if (value == 'settings') {
                      Navigator.pushNamed(context, '/user-profile-settings');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'settings',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'logout',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'You have admin privileges for EduShare platform management',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout Confirmation'),
        content: Text('Are you sure you want to logout from admin dashboard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await SupabaseService().signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/google-authentication',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
