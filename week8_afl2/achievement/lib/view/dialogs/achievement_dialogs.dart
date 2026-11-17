import 'package:flutter/material.dart';
import '../../viewmodels/tracker_viewmodel.dart';

class AchievementDialog {
  static Future<void> showAddAchievement(BuildContext context, TrackerViewModel vm) async {
    final result = await showDialog(
      context: context,
      builder: (_) => const _AddAchievementDialog(),
    );
    if (result != null) {
      vm.addAchievement(result['title']!, result['bio']!);
    }
  }

  static Future<void> showEditAchievement(
      BuildContext context, TrackerViewModel vm, int gameIndex, int achIndex) async {
    final ach = vm.games[gameIndex].achievements[achIndex];
    final result = await showDialog(
      context: context,
      builder: (_) => _AddAchievementDialog(
        initialTitle: ach.title,
        initialBio: ach.bio,
        isEditing: true,
      ),
    );
    if (result != null) {
      vm.editAchievement(gameIndex, achIndex, result['title']!, result['bio']!);
    }
  }
}

class _AddAchievementDialog extends StatefulWidget {
  final String initialTitle;
  final String initialBio;
  final bool isEditing;

  const _AddAchievementDialog({
    this.initialTitle = '',
    this.initialBio = '',
    this.isEditing = false,
  });

  @override
  State<_AddAchievementDialog> createState() => _AddAchievementDialogState();
}

class _AddAchievementDialogState extends State<_AddAchievementDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _bioController;
  final _bioFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _bioController = TextEditingController(text: widget.initialBio);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bioController.dispose();
    _bioFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      Navigator.pop(context, {
        'title': title,
        'bio': _bioController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Achievement' : 'Add Achievement'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Achievement Title'),
            autofocus: true,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _bioFocusNode.requestFocus(),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            focusNode: _bioFocusNode,
            decoration: const InputDecoration(labelText: 'Short bio / how to unlock'),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: Text(widget.isEditing ? 'Save' : 'Add')),
      ],
    );
  }
}
