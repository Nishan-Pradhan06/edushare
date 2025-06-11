import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/file_upload_widget.dart';
import './widgets/metadata_section_widget.dart';
import './widgets/post_form_widget.dart';
import './widgets/upload_progress_widget.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  String? selectedSubject;
  String? selectedSemester;
  String? selectedFaculty;
  String? selectedYear;
  String? selectedCategory;

  List<Map<String, dynamic>> uploadedFiles = [];
  List<String> tags = [];
  bool isUploading = false;
  bool isDraft = false;
  double uploadProgress = 0.0;

  // Mock data for dropdowns
  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Computer Science',
    'Biology',
    'English Literature',
    'History',
    'Economics',
    'Psychology',
    'Engineering'
  ];

  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ];

  final List<String> faculties = [
    'Engineering',
    'Science',
    'Arts',
    'Commerce',
    'Medicine',
    'Law',
    'Management',
    'Education'
  ];

  final List<String> years = ['2024', '2023', '2022', '2021', '2020'];

  final List<String> categories = [
    'Notes',
    'Question Papers',
    'Lab Sheets',
    'Assignments',
    'Projects',
    'Study Materials',
    'Reference Books'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addFile() {
    // Mock file addition
    setState(() {
      uploadedFiles.add({
        'name': 'Sample_Document_${uploadedFiles.length + 1}.pdf',
        'size': '2.5 MB',
        'type': 'PDF',
        'progress': 100.0,
        'isUploaded': true,
      });
    });
  }

  void _removeFile(int index) {
    setState(() {
      uploadedFiles.removeAt(index);
    });
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      setState(() {
        tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  void _saveDraft() {
    setState(() {
      isDraft = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _publishPost() {
    if (_formKey.currentState?.validate() ?? false) {
      if (uploadedFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please upload at least one file'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
        return;
      }

      setState(() {
        isUploading = true;
        uploadProgress = 0.0;
      });

      // Simulate upload progress
      _simulateUpload();
    }
  }

  void _simulateUpload() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        uploadProgress = i / 100;
      });
    }

    setState(() {
      isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post published successfully!'),
        backgroundColor: AppTheme.successLight,
      ),
    );

    // Navigator.pushNamed(context, '/home-feed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: Text('Save Draft'),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: isUploading ? null : _publishPost,
            child: Text('Publish'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: isUploading
          ? UploadProgressWidget(progress: uploadProgress)
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post Form Section
                    PostFormWidget(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                    ),

                    // File Upload Section
                    FileUploadWidget(
                      uploadedFiles: uploadedFiles,
                      onAddFile: _addFile,
                      onRemoveFile: _removeFile,
                    ),

                    // Metadata Section
                    MetadataSectionWidget(
                      subjects: subjects,
                      semesters: semesters,
                      faculties: faculties,
                      years: years,
                      categories: categories,
                      selectedSubject: selectedSubject,
                      selectedSemester: selectedSemester,
                      selectedFaculty: selectedFaculty,
                      selectedYear: selectedYear,
                      selectedCategory: selectedCategory,
                      onSubjectChanged: (value) =>
                          setState(() => selectedSubject = value),
                      onSemesterChanged: (value) =>
                          setState(() => selectedSemester = value),
                      onFacultyChanged: (value) =>
                          setState(() => selectedFaculty = value),
                      onYearChanged: (value) =>
                          setState(() => selectedYear = value),
                      onCategoryChanged: (value) =>
                          setState(() => selectedCategory = value),
                    ),

                    // Tags Section
                    _buildTagsSection(),

                    // Guidelines Section
                    _buildGuidelinesSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTagsSection() {
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
              'Tags',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: 'Add tags to improve discoverability',
                suffixIcon: IconButton(
                  onPressed: () => _addTag(_tagsController.text.trim()),
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              onFieldSubmitted: (value) => _addTag(value.trim()),
            ),
            if (tags.isNotEmpty) ...[
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          deleteIcon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 16,
                          ),
                          onDeleted: () => _removeTag(tag),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelinesSection() {
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Content Guidelines',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '• Ensure content is educational and relevant\n'
              '• Use clear, descriptive titles\n'
              '• Add appropriate tags for better discoverability\n'
              '• Respect copyright and intellectual property\n'
              '• Keep file sizes under 50MB per file',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
