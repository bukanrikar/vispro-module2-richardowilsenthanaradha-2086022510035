import 'package:flutter/material.dart';
import '../../viewmodels/tracker_viewmodel.dart';

class GameSidebar extends StatelessWidget {
  final TrackerViewModel vm;
  final VoidCallback onAddGame;

  const GameSidebar({super.key, required this.vm, required this.onAddGame});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      color: const Color(0xFF2B2D31),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: vm.games.length,
              itemBuilder: (context, index) {
                final isSelected = vm.selectedGameIndex == index;
                final game = vm.games[index];
                return Tooltip(
                  message: game.name,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => vm.selectGame(index),
                      child: Stack(
                        children: [
                          if (isSelected)
                            Positioned(
                              left: 0, top: 14, bottom: 14,
                              child: Container(
                                width: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.indigo : Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                game.name.isNotEmpty ? game.name[0].toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Tooltip(
              message: 'Add Game',
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.greenAccent),
                onPressed: onAddGame,
                style: IconButton.styleFrom(backgroundColor: Colors.grey.shade800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
