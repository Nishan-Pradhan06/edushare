import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    "isAuthenticated": false,
    "hasCompletedOnboarding": false,
    "userRole": null,
    "preferences": {"reduceMotion": false, "theme": "light"}
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Check for reduced motion preference
    final reduceMotion = _mockUserData["preferences"]["reduceMotion"] as bool;
    if (!reduceMotion) {
      _logoAnimationController.forward();
      _fadeAnimationController.forward();
    } else {
      // Skip animations if reduced motion is enabled
      _logoAnimationController.value = 1.0;
      _fadeAnimationController.value = 1.0;
    }
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _isInitializing = true;
        _hasError = false;
      });

      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchEssentialConfiguration(),
        _prepareCachedContent(),
      ]);

      // Minimum splash display time
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to initialize app. Please try again.';
          _isInitializing = false;
        });

        // Auto retry after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _hasError) {
            _retryInitialization();
          }
        });
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking Google authentication
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock authentication check - in real app, check with Google Auth
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user role preferences
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock loading preferences from local storage
  }

  Future<void> _fetchEssentialConfiguration() async {
    // Simulate fetching app configuration
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock API call for essential config
  }

  Future<void> _prepareCachedContent() async {
    // Simulate preparing cached educational content
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock content preparation
  }

  void _navigateToNextScreen() {
    final isAuthenticated = _mockUserData["isAuthenticated"] as bool;
    final hasCompletedOnboarding =
        _mockUserData["hasCompletedOnboarding"] as bool;

    String nextRoute;

    if (isAuthenticated) {
      if (hasCompletedOnboarding) {
        nextRoute = '/home-feed';
      } else {
        nextRoute = '/onboarding-role-selection';
      }
    } else {
      nextRoute = '/google-authentication';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _retryInitialization() {
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to match brand colors
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: _hasError ? _buildErrorContent() : _buildSplashContent(),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: AnimatedBuilder(
              animation: _logoScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: _buildLogo(),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isInitializing) ...[
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Initializing EduShare...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'Educational Resource Sharing Platform',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'school',
            color: AppTheme.lightTheme.primaryColor,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'EduShare',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _retryInitialization,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  foregroundColor: AppTheme.lightTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/google-authentication');
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              child: Text(
                'Continue to Login',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.8),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
