import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/admin_dashboard/widgets/user_management_widget.dart

class UserManagementWidget extends StatefulWidget {
  final List<dynamic> users;
  final Function(String userId, String role) onUserRoleChanged;

  const UserManagementWidget({
    super.key,
    required this.users,
    required this.onUserRoleChanged,
  });

  @override
  State<UserManagementWidget> createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  String _searchQuery = '';
  String _selectedRoleFilter = 'All';
  final List<String> _roleFilters = [
    'All',
    'Student',
    'Educator',
    'Creator',
    'Admin'
  ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredUsers = widget.users.where((user) {
      bool matchesSearch = _searchQuery.isEmpty ||
          (user['email'] ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (user['full_name'] ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      bool matchesRole = _selectedRoleFilter == 'All' ||
          (user['role'] ?? 'Student') == _selectedRoleFilter;

      return matchesSearch && matchesRole;
    }).toList();

    return Column(
      children: [
        // Search and Filter Header
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search users by name or email...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.lightTheme.colorScheme.surface,
                ),
              ),
              SizedBox(height: 2.h),

              // Role Filter
              Row(
                children: [
                  Text(
                    'Filter by Role:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _roleFilters.map((role) {
                          bool isSelected = _selectedRoleFilter == role;
                          return Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: FilterChip(
                              label: Text(role),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedRoleFilter = role;
                                });
                              },
                              selectedColor: AppTheme
                                  .lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                              checkmarkColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Users List
        Expanded(
          child: filteredUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'group_off',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No users found',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Try adjusting your search or filter criteria',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildUserCard(dynamic user) {
    String email = user['email'] ?? 'No email';
    String fullName = user['full_name'] ??
        user['raw_user_meta_data']?['full_name'] ??
        'Unknown User';
    String role = user['role'] ?? 'Student';
    String lastSignIn = user['last_sign_in_at'] ?? 'Never';
    bool isOnline = user['last_sign_in_at'] != null &&
        DateTime.parse(user['last_sign_in_at'])
            .isAfter(DateTime.now().subtract(Duration(minutes: 15)));

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
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
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    child: Text(
                      fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 4.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      email,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        _buildRoleBadge(role),
                        SizedBox(width: 2.w),
                        if (isOnline)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Online',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onSelected: (value) {
                  if (value.startsWith('role_')) {
                    String newRole = value.substring(5);
                    _showRoleChangeDialog(user, newRole);
                  } else if (value == 'view_profile') {
                    _showUserDetails(user);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view_profile',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text('View Profile'),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  ...[
                    'Student',
                    'Educator',
                    'Creator',
                    'Admin'
                  ].where((r) => r != role).map((r) => PopupMenuItem(
                        value: 'role_$r',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'admin_panel_settings',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text('Make $r'),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    switch (role) {
      case 'Admin':
        color = AppTheme.lightTheme.colorScheme.error;
        break;
      case 'Creator':
        color = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'Educator':
        color = AppTheme.lightTheme.colorScheme.secondary;
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        role,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showRoleChangeDialog(dynamic user, String newRole) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change User Role'),
        content: Text(
          'Are you sure you want to change ${user['full_name'] ?? user['email']}\'s role to $newRole?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onUserRoleChanged(user['id'], newRole);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', user['full_name'] ?? 'Unknown'),
            _buildDetailRow('Email', user['email'] ?? 'No email'),
            _buildDetailRow('Role', user['role'] ?? 'Student'),
            _buildDetailRow('Last Sign In', user['last_sign_in_at'] ?? 'Never'),
            _buildDetailRow('Created', user['created_at'] ?? 'Unknown'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
