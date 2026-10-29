import 'package:flutter/material.dart';
import 'models/library_repository.dart';
import 'viewmodels/library_view_model.dart';
import 'views/library_screen.dart';

void main() {
  final repository = LibraryRepository();
  final viewModel = LibraryViewModel(repository);
  
  runApp(MyApp(vm: viewModel));
}

class MyApp extends StatelessWidget {
  final LibraryViewModel vm;
  const MyApp({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library System',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: LibraryScreen(vm: vm),
    );
  }
}