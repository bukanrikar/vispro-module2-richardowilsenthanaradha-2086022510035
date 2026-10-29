import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onBorrow;

  const BookCard({super.key, required this.book, required this.onBorrow});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${book.author} • Stock: ${book.stock}'),
        trailing: book.stock > 0
            ? ElevatedButton(
                onPressed: onBorrow,
                child: const Text('Borrow'),
              )
            : const Text('Out of Stock', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}