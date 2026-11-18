import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/achievement_model.dart';
import '../../domain/achievement_repository.dart';

class SharedPrefsAchievementRepository implements AchievementRepository {
  static const _storageKey = 'steam_tracker_data';

  @override
  Future loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }
    return {};
  }

  @override
  Future<void> saveData(List<GameTab> games, int selectedGameIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'games': games.map((g) => g.toJson()).toList(),
      'selectedGameIndex': selectedGameIndex,
    });
    await prefs.setString(_storageKey, data);
  }
}
