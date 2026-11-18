import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';
import '../domain/achievement_repository.dart';
import '../core/error_messages.dart';

class TrackerViewModel extends ChangeNotifier {
  final AchievementRepository _repository;

  List<GameTab> games = [];
  int selectedGameIndex = -1;
  String? errorMessage;

  TrackerViewModel(this._repository) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      errorMessage = null;
      final parsed = await _repository.loadData();
      if (parsed.isNotEmpty) {
        games = (parsed['games'] as List? ?? [])
            .map((g) => GameTab.fromJson(g as Map<String, dynamic>))
            .toList();

        final savedIndex = parsed['selectedGameIndex'] as int? ?? -1;
        selectedGameIndex = (savedIndex >= 0 && savedIndex < games.length)
            ? savedIndex
            : (games.isNotEmpty ? 0 : -1);
      }
    } catch (_) {
      games = [];
      selectedGameIndex = -1;
      errorMessage = ErrorMessages.loadFailed;
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    try {
      errorMessage = null;
      await _repository.saveData(games, selectedGameIndex);
    } catch (_) {
      errorMessage = ErrorMessages.saveFailed;
      notifyListeners();
    }
  }

  void addGame(String name) {
    games.add(GameTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      achievements: [],
    ));
    selectedGameIndex = games.length - 1;
    _saveData();
    notifyListeners();
  }

  void renameGame(int index, String newName) {
    if (index < 0 || index >= games.length) return;
    games[index].name = newName;
    _saveData();
    notifyListeners();
  }

  void deleteGame(int index) {
    if (index < 0 || index >= games.length) return;

    games.removeAt(index);

    if (games.isEmpty) {
      selectedGameIndex = -1;
    } else if (index < selectedGameIndex) {
      selectedGameIndex -= 1;
    } else if (index == selectedGameIndex && selectedGameIndex >= games.length) {
      selectedGameIndex = games.length - 1;
    }

    _saveData();
    notifyListeners();
  }

  void selectGame(int index) {
    if (index < 0 || index >= games.length) return;
    selectedGameIndex = index;
    _saveData();
    notifyListeners();
  }

  void setAchievementState(int gameIndex, int achIndex, AchievementState newState) {
    if (gameIndex < 0 || gameIndex >= games.length) return;
    final achievements = games[gameIndex].achievements;
    if (achIndex < 0 || achIndex >= achievements.length) return;
    
    if (achievements[achIndex].state == newState) {
      achievements[achIndex].state = AchievementState.pending;
    } else {
      achievements[achIndex].state = newState;
    }
    
    _saveData();
    notifyListeners();
  }

  void addAchievement(String title, String bio) {
    if (selectedGameIndex < 0) return;
    games[selectedGameIndex].achievements.add(Achievement(title: title, bio: bio));
    _saveData();
    notifyListeners();
  }

  void editAchievement(int gameIndex, int achIndex, String newTitle, String newBio) {
    if (gameIndex < 0 || gameIndex >= games.length) return;
    final achievements = games[gameIndex].achievements;
    if (achIndex < 0 || achIndex >= achievements.length) return;
    achievements[achIndex].title = newTitle;
    achievements[achIndex].bio = newBio;
    _saveData();
    notifyListeners();
  }

  void deleteAchievement(int gameIndex, int achIndex) {
    if (gameIndex < 0 || gameIndex >= games.length) return;
    final achievements = games[gameIndex].achievements;
    if (achIndex < 0 || achIndex >= achievements.length) return;
    achievements.removeAt(achIndex);
    _saveData();
    notifyListeners();
  }
}
