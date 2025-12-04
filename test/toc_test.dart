import 'package:flutter/foundation.dart';
import 'package:pdf_toc/utils/toc_converter.dart';

void main() {
  final samples = [
    'Chapter 1 1',
    '1. Introduction 1',
    '1.1 Sub 2',
    '第一章 引言 1',
    'Section 1 (3)',
    'Title......5',
  ];

  for (final s in samples) {
    final entries = TocConverter.convert(s);
    debugPrint('Input: "$s" => ${entries.length} entries');
    for (final e in entries) {
      debugPrint(
          '  index:${e.index} title:"${e.title}" page:${e.page} real:${e.realPage} level:${e.level}');
    }
  }
}
