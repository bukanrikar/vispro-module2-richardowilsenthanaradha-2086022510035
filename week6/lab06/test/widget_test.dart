import 'package:flutter_test/flutter_test.dart';
import 'package:lab06/main.dart';
import 'package:lab06/models/library_repository.dart';
import 'package:lab06/viewmodels/library_view_model.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    final repository = LibraryRepository();
    final viewModel = LibraryViewModel(repository);

    await tester.pumpWidget(MyApp(vm: viewModel));

    expect(find.byType(MyApp), findsOneWidget);
  });
}