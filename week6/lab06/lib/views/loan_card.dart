import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/loan.dart';
import '../viewmodels/display_status.dart';
import 'status_chip.dart';
import 'views_helper.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final Book book;
  final DisplayStatus currentStatus;
  final double currentFine;
  final VoidCallback onReturn;

  const LoanCard({
    super.key,
    required this.loan,
    required this.book,
    required this.currentStatus,
    required this.currentFine,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                StatusChip(status: currentStatus),
              ],
            ),
            Text('Student: ${loan.studentId}'),
            Text('Due: ${ViewsHelper.formatDate(loan.dueDate)}'),
            if (currentFine > 0)
              Text('Current Fine: Rp ${currentFine.toStringAsFixed(0)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onReturn,
              child: const Text('Return Book'),
            )
          ],
        ),
      ),
    );
  }
}