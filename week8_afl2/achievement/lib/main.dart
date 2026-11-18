import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'data/shared_prefs_achievement_repository.dart';
import 'viewmodels/tracker_viewmodel.dart';
import 'view/tracker_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(420, 540),
    minimumSize: Size(360, 420),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final repository = SharedPrefsAchievementRepository();
  final viewModel = TrackerViewModel(repository);

  runApp(AchievementTrackerApp(viewModel: viewModel));
}

class AchievementTrackerApp extends StatefulWidget {
  final TrackerViewModel viewModel;
  const AchievementTrackerApp({super.key, required this.viewModel});

  @override
  State<AchievementTrackerApp> createState() => _AchievementTrackerAppState();
}

class _AchievementTrackerAppState extends State<AchievementTrackerApp> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF313338),
        cardColor: const Color(0xFF3A3C41),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF2B2D31),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1F22),
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      home: TrackerScreen(vm: widget.viewModel),
    );
  }
}
