import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/admin_dashboard/widgets/admin_stats_widget.dart

class AdminStatsWidget extends StatelessWidget {
  final List<dynamic> users;
  final List<dynamic> posts;

  const AdminStatsWidget({
    super.key,
    required this.users,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    int totalUsers = users.length;
    int totalPosts = posts.length;
    int activeUsers =
        users.where((user) => user['last_sign_in_at'] != null).length;
    int pendingPosts =
        posts.where((post) => post['status'] == 'pending').length;

    // Role distribution
    Map<String, int> roleDistribution = {};
    for (var user in users) {
      String role = user['role'] ?? 'Student';
      roleDistribution[role] = (roleDistribution[role] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          Text(
            'Platform Overview',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 3.h,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                'Total Users',
                totalUsers.toString(),
                'group',
                AppTheme.lightTheme.colorScheme.primary,
              ),
              _buildStatCard(
                'Total Posts',
                totalPosts.toString(),
                'content_copy',
                AppTheme.lightTheme.colorScheme.secondary,
              ),
              _buildStatCard(
                'Active Users',
                activeUsers.toString(),
                'person_check',
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildStatCard(
                'Pending Posts',
                pendingPosts.toString(),
                'pending',
                AppTheme.lightTheme.colorScheme.error,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Role Distribution Chart
          Text(
            'User Role Distribution',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          Container(
            height: 30.h,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: roleDistribution.isNotEmpty
                ? PieChart(
                    PieChartData(
                      sections: _buildPieChartSections(roleDistribution),
                      sectionsSpace: 0,
                      centerSpaceRadius: 8.w,
                      startDegreeOffset: -90,
                    ),
                  )
                : Center(
                    child: Text(
                      'No data available',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
          ),

          SizedBox(height: 3.h),

          // Legend
          if (roleDistribution.isNotEmpty) ..._buildLegend(roleDistribution),

          SizedBox(height: 4.h),

          // Recent Activity
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Manage Users',
                  'group',
                  AppTheme.lightTheme.colorScheme.primary,
                  () {
                    // Switch to users tab
                    DefaultTabController.of(context).animateTo(1);
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildActionButton(
                  'Review Content',
                  'content_copy',
                  AppTheme.lightTheme.colorScheme.secondary,
                  () {
                    // Switch to content tab
                    DefaultTabController.of(context).animateTo(2);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      Map<String, int> roleDistribution) {
    List<Color> colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      AppTheme.lightTheme.colorScheme.error,
    ];

    int index = 0;
    return roleDistribution.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;

      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 15.w,
        titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(Map<String, int> roleDistribution) {
    List<Color> colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      AppTheme.lightTheme.colorScheme.error,
    ];

    int index = 0;
    return roleDistribution.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;

      return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              '${entry.key}: ${entry.value}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildActionButton(
      String title, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
