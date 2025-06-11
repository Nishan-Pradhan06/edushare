import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PostFormWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const PostFormWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      color: ColorScheme.of(context).onPrimary,
      shadowColor: AppTheme.shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post Details',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),

            // Title Field
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Post Title *',
                hintText: 'Enter a descriptive title for your post',
                counterText: '${titleController.text.length}/100',
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                if (value.trim().length < 5) {
                  return 'Title must be at least 5 characters';
                }
                return null;
              },
              onChanged: (value) {
                // Trigger rebuild to update counter
              },
            ),

            SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Provide a detailed description of your content...',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 500,
              validator: (value) {
                if (value != null && value.trim().length > 500) {
                  return 'Description cannot exceed 500 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
