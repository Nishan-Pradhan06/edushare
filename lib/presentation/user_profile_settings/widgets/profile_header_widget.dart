import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditProfile;
  final VoidCallback onImageEdit;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditProfile,
    required this.onImageEdit,
  });

  @override
  Widget build(BuildContext context) {
    final stats = userData["stats"] as Map<String, dynamic>;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image and Edit Button
          Stack(
            children: [
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData["avatar"] ?? "",
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onImageEdit,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.cardColor,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Name and Role
          Text(
            userData["name"] ?? "Unknown User",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Role Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getRoleColor(userData["role"]).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getRoleColor(userData["role"]),
                width: 1,
              ),
            ),
            child: Text(
              userData["role"] ?? "Student",
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: _getRoleColor(userData["role"]),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Statistics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                "Posts",
                stats["postsShared"]?.toString() ?? "0",
              ),
              _buildDivider(),
              _buildStatItem(
                "Bookmarks",
                stats["bookmarksSaved"]?.toString() ?? "0",
              ),
              _buildDivider(),
              _buildStatItem(
                "Followers",
                stats["followers"]?.toString() ?? "0",
              ),
              _buildDivider(),
              _buildStatItem(
                "Following",
                stats["following"]?.toString() ?? "0",
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // // Edit Profile Button
          // SizedBox(
          //   width: double.infinity,
          //   child: OutlinedButton.icon(
          //     onPressed: onEditProfile,
          //     icon: CustomIconWidget(
          //       iconName: 'edit',
          //       color: AppTheme.lightTheme.primaryColor,
          //       size: 18,
          //     ),
          //     label: Text('Edit Profile'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 4.h,
      width: 1,
      color: AppTheme.lightTheme.dividerColor,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'creator':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'admin':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
