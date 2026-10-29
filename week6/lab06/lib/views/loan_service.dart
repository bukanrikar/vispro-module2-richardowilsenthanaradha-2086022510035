import '../models/book.dart';
import '../models/loan.dart';

class LoanService {
  static const double weeklyFine = 5000.0;
  static DateTime getSixMonthsLater(DateTime dueDate) {
    return DateTime(dueDate.year, dueDate.month + 6, dueDate.day);
  }

  static double calculateFine(Loan loan, Book book, DateTime currentDate) {
    if (loan.finalFine > 0) return loan.finalFine;
    final endDate = loan.returnDate ?? currentDate;
    final overdueDays = endDate.difference(loan.dueDate).inDays;

    if (overdueDays <= 0) return 0.0;
    final completedWeeks = overdueDays ~/ 7;
    return completedWeeks * weeklyFine;
  }

  static BookStatus getStatus(Loan loan, DateTime currentDate) {
    final endDate = loan.returnDate ?? currentDate;
    final overdueDays = endDate.difference(loan.dueDate).inDays;

    if (overdueDays <= 0) return BookStatus.borrowed;
    
    final sixMonthsMark = getSixMonthsLater(loan.dueDate);
    if (endDate.isAfter(sixMonthsMark) || endDate.isAtSameMomentAs(sixMonthsMark)) {
      return BookStatus.missing;
    }
    return BookStatus.overdue;
  }
}