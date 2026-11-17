import 'package:flutter/material.dart';
import '../../models/achievement_model.dart';
import '../../viewmodels/tracker_viewmodel.dart';
import '../dialogs/app_dialogs.dart';

class AchievementList extends StatelessWidget {
  final TrackerViewModel vm;
  const AchievementList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.selectedGameIndex == -1) {
      return const _EmptyState(
        icon: Icons.videogame_asset_outlined,
        title: 'No game selected',
        subtitle: 'Pick a game from the sidebar, or add a new one.',
      );
    }

    final game = vm.games[vm.selectedGameIndex];
    if (game.achievements.isEmpty) {
      return const _EmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'No achievements yet',
        subtitle: 'Click the + icon above to add one!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: game.achievements.length,
      itemBuilder: (context, index) {
        final ach = game.achievements[index];
        
        Color cardColor = const Color(0xFF3A3C41);
        if (ach.isDone) {
          cardColor = const Color(0xFF284B38);
        } else if (ach.isImpossible) {
          cardColor = const Color(0xFF4B2828);
        }

        return Card(
          color: cardColor,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              ach.title,
              style: TextStyle(
                color: ach.isDone || ach.isImpossible ? Colors.white70 : Colors.white,
                decoration: ach.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: ach.bio.isNotEmpty
                ? Text(
                    ach.bio,
                    style: TextStyle(color: ach.isDone || ach.isImpossible ? Colors.white54 : Colors.grey),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    ach.isDone ? Icons.check_circle : Icons.check_circle_outline,
                    size: 20,
                    color: ach.isDone ? Colors.greenAccent : Colors.grey,
                  ),
                  tooltip: ach.isDone ? 'Mark as pending' : 'Mark as done',
                  onPressed: () => vm.setAchievementState(vm.selectedGameIndex, index, AchievementState.done),
                ),
                IconButton(
                  icon: Icon(
                    ach.isImpossible ? Icons.block : Icons.block_outlined,
                    size: 20,
                    color: ach.isImpossible ? Colors.redAccent : Colors.grey,
                  ),
                  tooltip: ach.isImpossible ? 'Mark as pending' : 'Mark as impossible',
                  onPressed: () => vm.setAchievementState(vm.selectedGameIndex, index, AchievementState.impossible),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                  tooltip: 'Options',
                  onSelected: (value) {
                    if (value == 'edit') {
                      AppDialogs.showEditAchievement(context, vm, vm.selectedGameIndex, index);
                    } else if (value == 'delete') {
                      vm.deleteAchievement(vm.selectedGameIndex, index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16, color: Colors.white70),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 16, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
