import 'dart:convert';
import 'package:flutter/services.dart';
import 'book.dart';

class LibraryRepository {
  Future<List<Book>> loadBooks() async {
    final String response = await rootBundle.loadString('assets/books.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => Book.fromJson(json)).toList();
  }
}