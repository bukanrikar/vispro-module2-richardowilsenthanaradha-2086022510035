import 'package:flutter/material.dart';
import '../../viewmodels/tracker_viewmodel.dart';
import 'game_dialogs.dart';
import 'achievement_dialogs.dart';

class AppDialogs {
  static Future<void> showAddGame(BuildContext context, TrackerViewModel vm) =>
      GameDialogs.showAddGame(context, vm);

  static Future<void> showRenameGame(BuildContext context, TrackerViewModel vm, int index) =>
      GameDialogs.showRenameGame(context, vm, index);

  static Future<void> showAddAchievement(BuildContext context, TrackerViewModel vm) =>
      AchievementDialog.showAddAchievement(context, vm);

  static Future<void> showEditAchievement(
          BuildContext context, TrackerViewModel vm, int gameIndex, int achIndex) =>
      AchievementDialog.showEditAchievement(context, vm, gameIndex, achIndex);

  static Future<bool> confirmDeleteGame(BuildContext context, String gameName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete game?'),
        content: Text('This permanently deletes "$gameName" and all of its achievements.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
