enum AchievementState { pending, done, impossible }

class Achievement {
  String title;
  String bio;
  AchievementState state;

  Achievement({
    required this.title,
    required this.bio,
    this.state = AchievementState.pending,
  });

  bool get isDone => state == AchievementState.done;
  bool get isImpossible => state == AchievementState.impossible;

  Map<String, dynamic> toJson() => {
        'title': title,
        'bio': bio,
        'state': state.index,
      };

  factory Achievement.fromJson(Map<String, dynamic> json) {
    AchievementState parsedState = AchievementState.pending;
    if (json.containsKey('state')) {
      final index = json['state'] as int? ?? 0;
      parsedState = AchievementState.values[index.clamp(0, AchievementState.values.length - 1)];
    } else if (json.containsKey('isDone')) {
      final isDone = json['isDone'] as bool? ?? false;
      parsedState = isDone ? AchievementState.done : AchievementState.pending;
    }
    return Achievement(
      title: json['title'] ?? '',
      bio: json['bio'] ?? '',
      state: parsedState,
    );
  }
}

class GameTab {
  String id;
  String name;
  List<Achievement> achievements;

  GameTab({required this.id, required this.name, required this.achievements});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'achievements': achievements.map((a) => a.toJson()).toList(),
      };

  factory GameTab.fromJson(Map<String, dynamic> json) => GameTab(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] ?? 'Unnamed Game',
        achievements: (json['achievements'] as List? ?? [])
            .map((a) => Achievement.fromJson(a as Map<String, dynamic>))
            .toList(),
      );
}
