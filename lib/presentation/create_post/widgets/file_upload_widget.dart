import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FileUploadWidget extends StatelessWidget {
  final List<Map<String, dynamic>> uploadedFiles;
  final VoidCallback onAddFile;
  final Function(int) onRemoveFile;

  const FileUploadWidget({
    super.key,
    required this.uploadedFiles,
    required this.onAddFile,
    required this.onRemoveFile,
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
              'Upload Files',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),

            // Upload Area
            GestureDetector(
              onTap: onAddFile,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'cloud_upload',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to browse files',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Supports PDF, DOC, DOCX, Images (Max 50MB)',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Uploaded Files List
            if (uploadedFiles.isNotEmpty) ...[
              Text(
                'Uploaded Files (${uploadedFiles.length})',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: uploadedFiles.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final file = uploadedFiles[index];
                  return _buildFileItem(file, index);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file, int index) {
    final bool isUploaded = file['isUploaded'] ?? false;
    final double progress = (file['progress'] ?? 0.0).toDouble();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // File Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getFileIcon(file['type'] ?? ''),
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),

          SizedBox(width: 12),

          // File Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name'] ?? 'Unknown File',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      file['size'] ?? '0 MB',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 8),
                    if (!isUploaded) ...[
                      Text(
                        '${(progress * 100).toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ] else ...[
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successLight,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Uploaded',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.successLight,
                        ),
                      ),
                    ],
                  ],
                ),
                if (!isUploaded) ...[
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Remove Button
          IconButton(
            onPressed: () => onRemoveFile(index),
            icon: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.errorLight,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      case 'image':
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'insert_drive_file';
    }
  }
}
