import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CreateCollectionModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onCollectionCreated;

  const CreateCollectionModal({
    super.key,
    required this.onCollectionCreated,
  });

  @override
  State<CreateCollectionModal> createState() => _CreateCollectionModalState();
}

class _CreateCollectionModalState extends State<CreateCollectionModal> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedIcon = 'folder';
  Color _selectedColor = AppTheme.primaryLight;
  bool _isPrivate = false;

  final List<String> _availableIcons = [
    'folder',
    'book',
    'science',
    'calculate',
    'code',
    'quiz',
    'school',
    'library_books',
    'assignment',
    'psychology',
    'biotech',
    'functions',
  ];

  final List<Color> _availableColors = [
    AppTheme.primaryLight,
    AppTheme.secondaryLight,
    AppTheme.accentLight,
    AppTheme.successLight,
    AppTheme.warningLight,
    AppTheme.errorLight,
    Color(0xFF9C27B0), // Purple
    Color(0xFF607D8B), // Blue Grey
    Color(0xFF795548), // Brown
    Color(0xFF009688), // Teal
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF3F51B5), // Indigo
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createCollection() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a collection name'),
          backgroundColor: AppTheme.errorLight));
      return;
    }

    final collectionData = {
      'name': _nameController.text.trim(),
      'icon': _selectedIcon,
      'color': _selectedColor,
      'isPrivate': _isPrivate,
    };

    widget.onCollectionCreated(collectionData);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Collection "${_nameController.text.trim()}" created'),
        backgroundColor: AppTheme.successLight));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          // Handle
          Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2))),
          // Header
          Padding(
              padding: EdgeInsets.all(20),
              child: Row(children: [
                Text('Create Collection',
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Spacer(),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant))),
              ])),
          Divider(height: 1),
          // Content
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Collection Name
                        Text('Collection Name',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 12),
                        TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                hintText: 'Enter collection name',
                                prefixIcon: CustomIconWidget(
                                    iconName: 'edit',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20))),
                        SizedBox(height: 32),
                        // Icon Selection
                        Text('Choose Icon',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 16),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              final icon = _availableIcons[index];
                              final isSelected = icon == _selectedIcon;
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIcon = icon;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? _selectedColor.withValues(
                                                  alpha: 0.1)
                                              : AppTheme.lightTheme.colorScheme
                                                  .surfaceContainerHighest,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: isSelected
                                                  ? _selectedColor
                                                  : AppTheme.lightTheme
                                                      .colorScheme.outline,
                                              width: isSelected ? 2 : 1)),
                                      child: Center(
                                          child: CustomIconWidget(
                                              iconName: icon,
                                              color: isSelected
                                                  ? _selectedColor
                                                  : AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                              size: 24))));
                            }),
                        SizedBox(height: 32),
                        // Color Selection
                        Text('Choose Color',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 16),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1),
                            itemCount: _availableColors.length,
                            itemBuilder: (context, index) {
                              final color = _availableColors[index];
                              final isSelected = color == _selectedColor;
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = color;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: isSelected
                                                  ? AppTheme.lightTheme
                                                      .colorScheme.onSurface
                                                  : Colors.transparent,
                                              width: 3)),
                                      child: isSelected
                                          ? Center(
                                              child: CustomIconWidget(
                                                  iconName: 'check',
                                                  color: Colors.white,
                                                  size: 20))
                                          : null));
                            }),
                        SizedBox(height: 32),
                        // Privacy Setting
                        Row(children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Private Collection',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text('Only you can see this collection',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant)),
                              ])),
                          Switch(
                              value: _isPrivate,
                              onChanged: (value) {
                                setState(() {
                                  _isPrivate = value;
                                });
                              }),
                        ]),
                      ]))),
          // Create Button
          Container(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _createCollection,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16)),
                      child: Text('Create Collection',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))))),
        ]));
  }
}
