import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({super.key});

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      color: ColorScheme.of(context).onPrimary,
      shadowColor: AppTheme.shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonHeader(),
                const SizedBox(height: 12),
                _buildSkeletonContent(),
                const SizedBox(height: 12),
                _buildSkeletonThumbnail(),
                const SizedBox(height: 12),
                _buildSkeletonTags(),
                const SizedBox(height: 12),
                _buildSkeletonFooter(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Row(
      children: [
        _buildSkeletonCircle(40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonBox(120, 16),
              const SizedBox(height: 4),
              _buildSkeletonBox(80, 12),
            ],
          ),
        ),
        _buildSkeletonBox(60, 24),
      ],
    );
  }

  Widget _buildSkeletonContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeletonBox(double.infinity, 20),
        const SizedBox(height: 8),
        _buildSkeletonBox(double.infinity, 16),
        const SizedBox(height: 4),
        _buildSkeletonBox(200, 16),
      ],
    );
  }

  Widget _buildSkeletonThumbnail() {
    return _buildSkeletonBox(double.infinity, 160, borderRadius: 8);
  }

  Widget _buildSkeletonTags() {
    return Row(
      children: [
        _buildSkeletonBox(60, 24, borderRadius: 8),
        const SizedBox(width: 8),
        _buildSkeletonBox(80, 24, borderRadius: 8),
        const SizedBox(width: 8),
        _buildSkeletonBox(70, 24, borderRadius: 8),
      ],
    );
  }

  Widget _buildSkeletonFooter() {
    return Row(
      children: [
        _buildSkeletonBox(100, 24, borderRadius: 8),
        const Spacer(),
        _buildSkeletonBox(40, 16),
        const SizedBox(width: 16),
        _buildSkeletonBox(40, 16),
        const SizedBox(width: 16),
        _buildSkeletonBox(40, 16),
      ],
    );
  }

  Widget _buildSkeletonBox(double width, double height,
      {double borderRadius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline
            .withValues(alpha: _animation.value * 0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildSkeletonCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline
            .withValues(alpha: _animation.value * 0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
