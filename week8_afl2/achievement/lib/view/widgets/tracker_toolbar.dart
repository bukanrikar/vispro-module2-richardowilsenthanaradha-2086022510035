import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../../models/achievement_model.dart';
import '../../viewmodels/tracker_viewmodel.dart';

class TrackerToolbar extends StatelessWidget {
  final TrackerViewModel vm;
  final Function(String) onMenuSelected;
  final VoidCallback onAddAchievement;

  const TrackerToolbar({
    super.key,
    required this.vm,
    required this.onMenuSelected,
    required this.onAddAchievement,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = vm.selectedGameIndex >= 0;
    final List<Achievement> achievements =
        hasSelection ? vm.games[vm.selectedGameIndex].achievements : const [];
    final doneCount = achievements.where((a) => a.isDone).length;

    final leftPadding = Platform.isMacOS ? 78.0 : 16.0;

    return DragToMoveArea(
      child: Container(
        height: 50,
        color: const Color(0xFF1E1F22),
        padding: EdgeInsets.only(left: leftPadding, right: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      hasSelection ? vm.games[vm.selectedGameIndex].name : 'Achievement Tracker',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  if (hasSelection) ...[
                    const SizedBox(width: 8),
                    Text(
                      '($doneCount/${achievements.length})',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            if (hasSelection)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: onAddAchievement,
                tooltip: 'Add Achievement',
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              tooltip: 'Menu',
              onSelected: onMenuSelected,
              itemBuilder: (context) => [
                if (hasSelection) ...[
                  const PopupMenuItem(value: 'rename', child: Text('Rename Game')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete Game')),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
