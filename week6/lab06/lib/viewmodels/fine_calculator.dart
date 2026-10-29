import '../models/book.dart';
import '../models/loan.dart';
import 'display_status.dart';

class FineCalculator {
  static const double weeklyFine = 5000.0;

  static double calculate(Loan loan, Book book, DateTime currentDate) {
    if (loan.finalFine > 0) return loan.finalFine;
    
    final endDate = loan.returnDate ?? currentDate;
    final overdueDays = endDate.difference(loan.dueDate).inDays;

    if (overdueDays <= 0) return 0.0;

    final sixMonthsMark = DateTime(loan.dueDate.year, loan.dueDate.month + 6, loan.dueDate.day);
    if (endDate.isAfter(sixMonthsMark) || endDate.isAtSameMomentAs(sixMonthsMark)) {
      return book.replacementPrice;
    }

    final completedWeeks = overdueDays ~/ 7;
    return completedWeeks * weeklyFine;
  }

  static DisplayStatus getStatus(Loan loan, DateTime currentDate) {
    final endDate = loan.returnDate ?? currentDate;
    final overdueDays = endDate.difference(loan.dueDate).inDays;

    if (overdueDays <= 0) return DisplayStatus.borrowed;

    // 6 Month check
    final sixMonthsMark = DateTime(loan.dueDate.year, loan.dueDate.month + 6, loan.dueDate.day);
    if (endDate.isAfter(sixMonthsMark) || endDate.isAtSameMomentAs(sixMonthsMark)) {
      return DisplayStatus.missing;
    }
    return DisplayStatus.overdue;
  }
}