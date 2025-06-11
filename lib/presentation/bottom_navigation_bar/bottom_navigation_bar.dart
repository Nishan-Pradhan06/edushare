import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../bookmarks_collections/bookmarks_collections.dart';
import '../create_post/create_post.dart';
import '../home_feed/home_feed.dart';
import '../search_filter/search_filter.dart';
import '../user_profile_settings/user_profile_settings.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentBottomNavIndex = 0;

  final List<Widget> _screens = [
    HomeFeed(),
    SearchFilter(),
    CreatePost(),
    BookmarksCollections(),
    UserProfileSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentBottomNavIndex, children: _screens),
      bottomNavigationBar: Material(
        elevation: 8,
        child: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          elevation: 8,
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _currentBottomNavIndex == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'search',
                color: _currentBottomNavIndex == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'add_circle',
                color: _currentBottomNavIndex == 3
                    ? AppTheme
                        .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                    : AppTheme.lightTheme.bottomNavigationBarTheme
                        .unselectedItemColor!,
                size: 24,
              ),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'bookmark',
                color: _currentBottomNavIndex == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _currentBottomNavIndex == 4
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
