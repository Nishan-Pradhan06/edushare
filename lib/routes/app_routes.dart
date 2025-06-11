// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../presentation/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/google_authentication/google_authentication.dart';
import '../presentation/onboarding_role_selection/onboarding_role_selection.dart';
import '../presentation/home_feed/home_feed.dart';
import '../presentation/search_filter/search_filter.dart';
import '../presentation/create_post/create_post.dart';
import '../presentation/post_detail_viewer/post_detail_viewer.dart';
import '../presentation/bookmarks_collections/bookmarks_collections.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';
import '../presentation/admin_login/admin_login.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String googleAuthentication = '/google-authentication';
  static const String onboardingRoleSelection = '/onboarding-role-selection';
  static const String bottomNavBar = '/bottomNavBar';
  static const String homeFeed = '/home-feed';
  static const String searchFilter = '/search-filter';
  static const String postDetailViewer = '/post-detail-viewer';
  static const String createPost = '/create-post';
  static const String bookmarksCollections = '/bookmarks-collections';
  static const String userProfileSettings = '/user-profile-settings';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminLogin = '/admin-login';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    googleAuthentication: (context) => const GoogleAuthentication(),
    onboardingRoleSelection: (context) => const OnboardingRoleSelection(),
    bottomNavBar: (context) => const BottomNavBarScreen(),
    homeFeed: (context) => const HomeFeed(),
    searchFilter: (context) => const SearchFilter(),
    postDetailViewer: (context) => const PostDetailViewer(),
    createPost: (context) => const CreatePost(),
    bookmarksCollections: (context) => const BookmarksCollections(),
    userProfileSettings: (context) => const UserProfileSettings(),
    adminDashboard: (context) => const AdminDashboard(),
    adminLogin: (context) => const AdminLogin(),
  };
}
