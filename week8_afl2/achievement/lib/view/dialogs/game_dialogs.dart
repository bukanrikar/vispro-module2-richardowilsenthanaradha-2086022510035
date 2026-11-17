import 'package:flutter/material.dart';
import '../../viewmodels/tracker_viewmodel.dart';

class GameDialogs {
  static Future<void> showAddGame(BuildContext context, TrackerViewModel vm) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _TextInputDialog(title: 'Add New Game', label: 'Game Title'),
    );
    if (name != null && name.isNotEmpty) {
      vm.addGame(name);
    }
  }

  static Future<void> showRenameGame(BuildContext context, TrackerViewModel vm, int index) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _TextInputDialog(title: 'Rename Game', label: 'Game Title', initialValue: vm.games[index].name),
    );
    if (name != null && name.isNotEmpty) {
      vm.renameGame(index, name);
    }
  }
}

class _TextInputDialog extends StatefulWidget {
  final String title;
  final String label;
  final String initialValue;
  const _TextInputDialog({required this.title, required this.label, this.initialValue = ''});

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: widget.label),
        autofocus: true,
        onSubmitted: (value) => Navigator.pop(context, value.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
