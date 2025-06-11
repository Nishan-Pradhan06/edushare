import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/auth_footer_widget.dart';
import './widgets/auth_header_widget.dart';
import './widgets/google_auth_button_widget.dart';

class GoogleAuthentication extends StatefulWidget {
  const GoogleAuthentication({super.key});

  @override
  State<GoogleAuthentication> createState() => _GoogleAuthenticationState();
}

class _GoogleAuthenticationState extends State<GoogleAuthentication> {
  bool _isLoading = false;

  // Mock authentication credentials for testing
  final Map<String, dynamic> _mockCredentials = {
    "validEmails": [
      "student@university.edu",
      "teacher@college.edu",
      "admin@school.edu"
    ],
    "testUser": {
      "email": "student@university.edu",
      "name": "John Doe",
      "role": "student"
    }
  };

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication success
      HapticFeedback.lightImpact();

      // Navigate to onboarding for new users or home for returning users
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding-role-selection');
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Authentication failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Authentication Error',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      AuthHeaderWidget(),
                      const SizedBox(height: 80),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Access thousands of study materials from students like you',
                          textAlign: TextAlign.center,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      GoogleAuthButtonWidget(
                        onPressed: _handleGoogleSignIn,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo Credentials:',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${_mockCredentials["testUser"]["email"]}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            Text(
                              'Name: ${_mockCredentials["testUser"]["name"]}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      // Replace Spacer with this:
                      const SizedBox(height: 48),

                      AuthFooterWidget(),
                      const SizedBox(height: 24),
                    ],
                  ),

                ),
              ),

              // Loading overlay
              if (_isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Authenticating...',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
