import 'package:flutter/material.dart';
import '../viewmodels/display_status.dart';

class StatusChip extends StatelessWidget {
  final DisplayStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case DisplayStatus.available: color = Colors.green; break;
      case DisplayStatus.borrowed: color = Colors.blue; break;
      case DisplayStatus.overdue: color = Colors.orange; break;
      case DisplayStatus.missing: color = Colors.red; break;
    }

    return Chip(
      label: Text(
        status.name.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      backgroundColor: color,
    );
  }
}