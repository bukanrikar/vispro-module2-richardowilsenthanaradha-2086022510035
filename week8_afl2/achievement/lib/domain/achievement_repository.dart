import '../models/achievement_model.dart';

abstract class AchievementRepository {
  Future loadData();
  Future<void> saveData(List<GameTab> games, int selectedGameIndex);
}
