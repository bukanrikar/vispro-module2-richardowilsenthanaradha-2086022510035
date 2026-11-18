import 'package:flutter/material.dart';
import '../viewmodels/tracker_viewmodel.dart';
import 'widgets/game_sidebar.dart';
import 'widgets/achievement_list.dart';
import 'widgets/tracker_toolbar.dart';
import 'dialogs/app_dialogs.dart';

class TrackerScreen extends StatelessWidget {
  final TrackerViewModel vm;

  const TrackerScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF313338),
          body: Column(
            children: [
              if (vm.errorMessage != null)
                Container(
                  color: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: double.infinity,
                  child: Text(
                    vm.errorMessage!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              TrackerToolbar(
                vm: vm,
                onAddAchievement: () => AppDialogs.showAddAchievement(context, vm),
                onMenuSelected: (value) => _handleMenuSelection(context, value),
              ),
              Expanded(
                child: Row(
                  children: [
                    GameSidebar(
                      vm: vm,
                      onAddGame: () => AppDialogs.showAddGame(context, vm),
                    ),
                    const VerticalDivider(width: 1, color: Colors.black26),
                    Expanded(child: AchievementList(vm: vm)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
    if (value == 'rename' && vm.selectedGameIndex >= 0) {
      AppDialogs.showRenameGame(context, vm, vm.selectedGameIndex);
    } else if (value == 'delete' && vm.selectedGameIndex >= 0) {
      await _confirmAndDelete(context, vm.selectedGameIndex);
    }
  }

  Future<void> _confirmAndDelete(BuildContext context, int index) async {
    final name = vm.games[index].name;
    final confirmed = await AppDialogs.confirmDeleteGame(context, name);
    if (!context.mounted || !confirmed) return;
    vm.deleteGame(index);
  }
}
