import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../provider/theme_toggle_provider.dart';
import './widgets/academic_info_card_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/role_management_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  int _currentIndex = 4; // Profile tab active
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _downloadQuality = 'High';

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@university.edu",
    "role": "Student",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "college": "MIT",
    "faculty": "Computer Science",
    "semester": "6th Semester",
    "batch": "2021-2025",
    "stats": {
      "postsShared": 24,
      "bookmarksSaved": 156,
      "followers": 89,
      "following": 67
    },
    "creatorApplicationStatus":
        "not_applied", // not_applied, pending, approved, rejected
    "isCreator": false,
    "isAdmin": false
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 10,
              children: [
                // Profile Header
                ProfileHeaderWidget(
                  userData: userData,
                  onEditProfile: _handleEditProfile,
                  onImageEdit: _handleImageEdit,
                ),

                // Academic Info Card
                AcademicInfoCardWidget(
                  userData: userData,
                  onEdit: _handleEditAcademicInfo,
                ),

                // Role Management Section
                if (!userData["isCreator"] && !userData["isAdmin"])
                  RoleManagementWidget(
                    applicationStatus: userData["creatorApplicationStatus"],
                    onBecomeCreator: _handleBecomeCreator,
                  ),

                // Settings Sections
                SettingsSectionWidget(
                  title: "Account",
                  items: [
                    SettingsItem(
                      icon: 'person',
                      title: 'Edit Profile',
                      onTap: _handleEditProfile,
                    ),
                    SettingsItem(
                      icon: 'school',
                      title: 'Academic Information',
                      onTap: _handleEditAcademicInfo,
                    ),
                    SettingsItem(
                      icon: 'privacy_tip',
                      title: 'Privacy Settings',
                      onTap: _handlePrivacySettings,
                    ),
                  ],
                ),

                SettingsSectionWidget(
                  title: "Notifications",
                  items: [
                    SettingsItem(
                      icon: 'notifications',
                      title: 'Push Notifications',
                      trailing: Switch(
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            _pushNotifications = value;
                          });
                        },
                      ),
                    ),
                    SettingsItem(
                      icon: 'email',
                      title: 'Email Notifications',
                      trailing: Switch(
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() {
                            _emailNotifications = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SettingsSectionWidget(
                  title: "Content",
                  items: [
                    SettingsItem(
                      icon: 'download',
                      title: 'Download Quality',
                      subtitle: _downloadQuality,
                      onTap: _handleDownloadQuality,
                    ),
                    SettingsItem(
                      icon: 'storage',
                      title: 'Offline Storage',
                      subtitle: '2.4 GB used',
                      onTap: _handleOfflineStorage,
                    ),
                    SettingsItem(
                      icon: 'clear',
                      title: 'Clear Cache',
                      subtitle: '156 MB cached',
                      onTap: _handleClearCache,
                    ),
                  ],
                ),

                SettingsSectionWidget(
                  title: "Appearance",
                  items: [
                    SettingsItem(
                      icon: 'dark_mode',
                      title: 'Dark Mode',
                      trailing: Consumer<ThemeNotifier>(
                        builder: (context, themeNotifier, child) {
                          return Switch(
                            value: themeNotifier.isDarkMode,
                            onChanged: (value) {
                              themeNotifier.toggleTheme(value);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Creator-specific settings
                if (userData["isCreator"])
                  SettingsSectionWidget(
                    title: "Creator Tools",
                    items: [
                      SettingsItem(
                        icon: 'analytics',
                        title: 'Content Analytics',
                        onTap: _handleContentAnalytics,
                      ),
                      SettingsItem(
                        icon: 'people',
                        title: 'Follower Management',
                        onTap: _handleFollowerManagement,
                      ),
                      SettingsItem(
                        icon: 'settings',
                        title: 'Posting Preferences',
                        onTap: _handlePostingPreferences,
                      ),
                    ],
                  ),

                // Admin-specific settings
                if (userData["isAdmin"])
                  SettingsSectionWidget(
                    title: "Admin Tools",
                    items: [
                      SettingsItem(
                        icon: 'admin_panel_settings',
                        title: 'Moderation Tools',
                        onTap: _handleModerationTools,
                      ),
                      SettingsItem(
                        icon: 'manage_accounts',
                        title: 'User Management',
                        onTap: _handleUserManagement,
                      ),
                    ],
                  ),

                SettingsSectionWidget(
                  title: "Support",
                  items: [
                    SettingsItem(
                      icon: 'help',
                      title: 'Help Center',
                      onTap: _handleHelpCenter,
                    ),
                    SettingsItem(
                      icon: 'feedback',
                      title: 'Send Feedback',
                      onTap: _handleSendFeedback,
                    ),
                    SettingsItem(
                      icon: 'info',
                      title: 'About EduShare',
                      onTap: _handleAbout,
                    ),
                  ],
                ),

                // Logout Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.error,
                      foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Logout',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleEditProfile() {
    // Navigate to edit profile screen or show modal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit Profile functionality')),
    );
  }

  void _handleImageEdit() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Camera functionality')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gallery functionality')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditAcademicInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit Academic Info functionality')),
    );
  }

  void _handleBecomeCreator() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Become a Creator'),
        content: Text(
            'Apply to become a content creator and share educational resources with the community.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                userData["creatorApplicationStatus"] = "pending";
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Creator application submitted!')),
              );
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _handlePrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Privacy Settings functionality')),
    );
  }

  void _handleDownloadQuality() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['High', 'Medium', 'Low']
              .map(
                (quality) => RadioListTile<String>(
                  title: Text(quality),
                  value: quality,
                  groupValue: _downloadQuality,
                  onChanged: (value) {
                    setState(() {
                      _downloadQuality = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _handleOfflineStorage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Offline Storage management')),
    );
  }

  void _handleClearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
            'This will clear all cached files and free up 156 MB of storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully!')),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _handleContentAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Content Analytics functionality')),
    );
  }

  void _handleFollowerManagement() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Follower Management functionality')),
    );
  }

  void _handlePostingPreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Posting Preferences functionality')),
    );
  }

  void _handleModerationTools() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Moderation Tools functionality')),
    );
  }

  void _handleUserManagement() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User Management functionality')),
    );
  }

  void _handleHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Help Center functionality')),
    );
  }

  void _handleSendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Send Feedback functionality')),
    );
  }

  void _handleAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About EduShare'),
        content: Text(
            'EduShare v1.0.0\n\nAn educational resource sharing platform for students and educators.\n\n© 2024 EduShare Team'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text(
            'Are you sure you want to logout? Make sure your data is synced before logging out.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/google-authentication',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
