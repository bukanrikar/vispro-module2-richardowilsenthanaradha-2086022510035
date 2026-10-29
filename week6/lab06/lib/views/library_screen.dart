import 'package:flutter/material.dart';
import '../viewmodels/library_view_model.dart';
import 'book_card.dart';
import 'borrowed_books_screen.dart';

class LibraryScreen extends StatefulWidget {
  final LibraryViewModel vm;
  const LibraryScreen({super.key, required this.vm});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library System')),
      body: _currentIndex == 0 
          ? _buildCatalogue() 
          : BorrowedBooksScreen(vm: widget.vm),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Catalogue'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Borrowed'),
        ],
      ),
    );
  }

  Widget _buildCatalogue() {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, child) {
        if (widget.vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: widget.vm.books.length,
          itemBuilder: (context, index) {
            final book = widget.vm.books[index];
            return BookCard(
              book: book,
              onBorrow: () {
                final result = widget.vm.borrowBook(book.id, 'STD-001');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.message),
                    backgroundColor: result.isSuccess ? Colors.green : Colors.red,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}