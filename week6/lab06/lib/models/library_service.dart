import 'book.dart';

class LibraryService {
  static bool canBorrow(Book book) {
    return book.stock > 0;
  }
}