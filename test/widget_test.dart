import 'package:clean_finance/features/finance/presentation/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SectionCard renders its child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionCard(
            child: Text('Contenido'),
          ),
        ),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
    expect(find.text('Contenido'), findsOneWidget);
  });
}
