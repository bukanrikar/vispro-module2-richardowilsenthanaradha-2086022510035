import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/loan.dart';
import '../models/library_repository.dart';
import '../models/library_service.dart';
import 'fine_calculator.dart';
import 'operation_result.dart';
import 'display_status.dart';

class LibraryViewModel extends ChangeNotifier {
  final LibraryRepository _repository;
  final List<Book> _books = [];
  final List<Loan> _loans = [];
  bool isLoading = true;

  DateTime currentDate = DateTime.now();

  List<Book> get books => List.unmodifiable(_books);
  List<Loan> get activeLoans => _loans.where((l) => l.returnDate == null).toList();

  LibraryViewModel(this._repository) {
    _init();
  }

  Future<void> _init() async {
    _books.addAll(await _repository.loadBooks());
    isLoading = false;
    notifyListeners();
  }

  OperationResult borrowBook(String bookId, String studentId) {
    final book = _books.firstWhere((b) => b.id == bookId);
    
    if (!LibraryService.canBorrow(book)) {
      return OperationResult.failure('Book is out of stock!');
    }

    final now = currentDate;
    _loans.add(Loan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      studentId: studentId,
      borrowDate: now,
      dueDate: now.add(const Duration(days: 7)),
    ));

    book.stock--;
    if (book.stock == 0) book.status = BookStatus.borrowed;
    
    notifyListeners();
    return OperationResult.success('Book borrowed successfully');
  }

  OperationResult returnBook(String loanId) {
    final loan = _loans.firstWhere((l) => l.id == loanId && l.returnDate == null);
    final book = _books.firstWhere((b) => b.id == loan.bookId);
    
    loan.returnDate = currentDate;
    loan.finalFine = calculateFine(loan, book);

    book.stock++;
    book.status = BookStatus.available;
    
    notifyListeners();
    return OperationResult.success('Book returned successfully');
  }

  double calculateFine(Loan loan, Book book) {
    return FineCalculator.calculate(loan, book, currentDate);
  }

  DisplayStatus getOverdueStatus(Loan loan) {
    return FineCalculator.getStatus(loan, currentDate);
  }

  double get totalFines {
    double total = 0;
    for (var loan in activeLoans) {
      final book = _books.firstWhere((b) => b.id == loan.bookId);
      total += calculateFine(loan, book);
    }
    return total;
  }
}