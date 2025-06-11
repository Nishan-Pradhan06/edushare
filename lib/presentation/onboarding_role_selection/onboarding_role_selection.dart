import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/academic_info_widget.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/role_selection_widget.dart';

class OnboardingRoleSelection extends StatefulWidget {
  const OnboardingRoleSelection({super.key});

  @override
  State<OnboardingRoleSelection> createState() =>
      _OnboardingRoleSelectionState();
}

class _OnboardingRoleSelectionState extends State<OnboardingRoleSelection> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String _selectedRole = '';
  String _selectedCollege = '';
  String _selectedFaculty = '';
  String _selectedYear = '';
  String _selectedBatch = '';

  final List<Map<String, dynamic>> _colleges = [
    {"id": 1, "name": "Harvard University"},
    {"id": 2, "name": "Stanford University"},
    {"id": 3, "name": "MIT"},
    {"id": 4, "name": "University of California, Berkeley"},
    {"id": 5, "name": "Oxford University"},
    {"id": 6, "name": "Cambridge University"},
  ];

  final List<Map<String, dynamic>> _faculties = [
    {"id": 1, "name": "Computer Science"},
    {"id": 2, "name": "Engineering"},
    {"id": 3, "name": "Business Administration"},
    {"id": 4, "name": "Medicine"},
    {"id": 5, "name": "Arts & Humanities"},
    {"id": 6, "name": "Natural Sciences"},
  ];

  final List<Map<String, dynamic>> _years = [
    {"id": 1, "name": "1st Year"},
    {"id": 2, "name": "2nd Year"},
    {"id": 3, "name": "3rd Year"},
    {"id": 4, "name": "4th Year"},
    {"id": 5, "name": "Graduate"},
  ];

  final List<Map<String, dynamic>> _batches = [
    {"id": 1, "name": "2024-2025"},
    {"id": 2, "name": "2023-2024"},
    {"id": 3, "name": "2022-2023"},
    {"id": 4, "name": "2021-2022"},
  ];

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/bottomNavBar',
      (route) => false,
    );
  }

  void _skipOnboarding() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/bottomNavBar',
      (route) => false,
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return true;
      case 1:
        return _selectedRole.isNotEmpty;
      case 2:
        return _selectedCollege.isNotEmpty &&
            _selectedFaculty.isNotEmpty &&
            _selectedYear.isNotEmpty &&
            _selectedBatch.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress and skip
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentStep > 0
                      ? GestureDetector(
                          onTap: _previousStep,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        )
                      : SizedBox(width: 8.w),
                  ProgressIndicatorWidget(
                    currentStep: _currentStep,
                    totalSteps: 3,
                  ),
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  OnboardingStepWidget(),
                  RoleSelectionWidget(
                    selectedRole: _selectedRole,
                    onRoleSelected: (role) {
                      setState(() {
                        _selectedRole = role;
                      });
                    },
                  ),
                  AcademicInfoWidget(
                    colleges: _colleges,
                    faculties: _faculties,
                    years: _years,
                    batches: _batches,
                    selectedCollege: _selectedCollege,
                    selectedFaculty: _selectedFaculty,
                    selectedYear: _selectedYear,
                    selectedBatch: _selectedBatch,
                    onCollegeChanged: (college) {
                      setState(() {
                        _selectedCollege = college;
                      });
                    },
                    onFacultyChanged: (faculty) {
                      setState(() {
                        _selectedFaculty = faculty;
                      });
                    },
                    onYearChanged: (year) {
                      setState(() {
                        _selectedYear = year;
                      });
                    },
                    onBatchChanged: (batch) {
                      setState(() {
                        _selectedBatch = batch;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Bottom action button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canProceed()
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.12),
                    foregroundColor: _canProceed()
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.38),
                    padding: EdgeInsets.symmetric(vertical: 4.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentStep == 2 ? 'Get Started' : 'Continue',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: _canProceed()
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.38),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
