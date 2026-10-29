import 'package:flutter/material.dart';
import '../viewmodels/library_view_model.dart';
import 'loan_card.dart';
import 'fine_summary.dart';

class BorrowedBooksScreen extends StatelessWidget {
  final LibraryViewModel vm;
  const BorrowedBooksScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        final activeLoans = vm.activeLoans;
        
        return Column(
          children: [
            FineSummary(totalFines: vm.totalFines),
            
            Expanded(
              child: activeLoans.isEmpty 
                ? const Center(child: Text('No active loans'))
                : ListView.builder(
                    itemCount: activeLoans.length,
                    itemBuilder: (context, index) {
                      final loan = activeLoans[index];
                      final book = vm.books.firstWhere((b) => b.id == loan.bookId);
                      final status = vm.getOverdueStatus(loan);
                      final fine = vm.calculateFine(loan, book);

                      return LoanCard(
                        loan: loan,
                        book: book,
                        currentStatus: status,
                        currentFine: fine,
                        onReturn: () => vm.returnBook(loan.id),
                      );
                    },
                  ),
            )
          ],
        );
      },
    );
  }
}