// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pdf_toc/ui/app.dart';

void main() {
  testWidgets('PDF TOC App launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PdfTOCApp());

    // Verify that the app loaded and contains expected elements
    expect(find.text('PDF-TOC'), findsWidgets);
    expect(find.byType(TextField), findsWidgets);
  });
}
