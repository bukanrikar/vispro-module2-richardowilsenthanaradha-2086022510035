import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement_model.dart';

class TrackerViewModel extends ChangeNotifier {
  static const _storageKey = 'steam_tracker_data';

  List<GameTab> games = [];
  int selectedGameIndex = -1;

  TrackerViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_storageKey);
      if (data != null) {
        final Map<String, dynamic> parsed = jsonDecode(data);
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
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'games': games.map((g) => g.toJson()).toList(),
      'selectedGameIndex': selectedGameIndex,
    });
    await prefs.setString(_storageKey, data);
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
