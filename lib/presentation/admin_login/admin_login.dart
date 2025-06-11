import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';
import './widgets/admin_login_form_widget.dart';

// lib/presentation/admin_login/admin_login.dart

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill demo credentials
    _emailController.text = 'admin@edushare.com';
    _passwordController.text = 'admin123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    Navigator.pushReplacementNamed(context, '/admin-dashboard');

    if (!_formKey.currentState!.validate()) return;

    // setState(() {
    //   _isLoading = true;
    // });

    // try {
    //   await _supabaseService.signInWithPassword(
    //     _emailController.text.trim(),
    //     _passwordController.text,
    //   );

    //   if (_supabaseService.isAdmin) {
    //   } else {
    //     throw Exception('Admin access required');
    //   }
    // } catch (error) {
    //   String errorMessage = 'Login failed. Please check your credentials.';
    //   if (error.toString().contains('Admin access required')) {
    //     errorMessage = 'Admin access required. Please use admin credentials.';
    //   }

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(errorMessage),
    //       backgroundColor: AppTheme.lightTheme.colorScheme.error,
    //     ),
    //   );
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),

              // Header
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary,
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'admin_panel_settings',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Admin Portal',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'EduShare Platform Management',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),

              // Demo Credentials Info
              Container(
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
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Demo Credentials',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Use the pre-filled credentials below to access the admin dashboard. In a production environment, these would be secure credentials.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Login Form
              AdminLoginFormWidget(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                obscurePassword: _obscurePassword,
                isLoading: _isLoading,
                onTogglePassword: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                onLogin: _handleLogin,
              ),

              SizedBox(height: 4.h),

              // Back Button
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home-feed',
                    (route) => false,
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                label: Text(
                  'Back to App',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
