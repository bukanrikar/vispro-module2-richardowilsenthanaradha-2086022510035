import 'package:flutter/material.dart';
import '../viewmodels/tracker_viewmodel.dart';
import 'widgets/game_sidebar.dart';
import 'widgets/achievement_list.dart';
import 'widgets/tracker_toolbar.dart';
import 'dialogs/app_dialogs.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final TrackerViewModel vm = TrackerViewModel();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF313338),
          body: Column(
            children: [
              TrackerToolbar(
                vm: vm,
                onAddAchievement: () => AppDialogs.showAddAchievement(context, vm),
                onMenuSelected: (value) => _handleMenuSelection(value),
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

  Future<void> _handleMenuSelection(String value) async {
    if (value == 'rename' && vm.selectedGameIndex >= 0) {
      AppDialogs.showRenameGame(context, vm, vm.selectedGameIndex);
    } else if (value == 'delete' && vm.selectedGameIndex >= 0) {
      await _confirmAndDelete(vm.selectedGameIndex);
    }
  }

  Future<void> _confirmAndDelete(int index) async {
    final name = vm.games[index].name;
    final confirmed = await AppDialogs.confirmDeleteGame(context, name);
    if (!mounted || !confirmed) return;
    vm.deleteGame(index);
  }
}
