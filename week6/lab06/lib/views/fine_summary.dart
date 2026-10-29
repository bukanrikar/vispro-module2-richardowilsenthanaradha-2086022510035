import 'package:flutter/material.dart';

class FineSummary extends StatelessWidget {
  final double totalFines;

  const FineSummary({super.key, required this.totalFines});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Outstanding Fines:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Rp ${totalFines.toStringAsFixed(0)}', 
              style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}