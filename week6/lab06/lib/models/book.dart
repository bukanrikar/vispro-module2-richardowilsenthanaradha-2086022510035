enum BookStatus { available, borrowed, overdue, missing }

class Book {
  final String id;
  final String title;
  final String author;
  final double replacementPrice;
  int stock;
  BookStatus status;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    required this.stock,
    this.status = BookStatus.available,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      replacementPrice: json['replacementPrice'].toDouble(),
      stock: json['stock'],
    );
  }
}