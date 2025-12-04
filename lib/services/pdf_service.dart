import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:pdf_toc/models/toc_entry.dart';

class PdfService {
  /// Add bookmarks (outline) to an existing PDF file using a list of
  /// [TocEntry]. Returns the path to the newly written PDF file.
  static Future<String> addBookmarks(
    String pdfPath,
    List<TocEntry> entries,
  ) async {
    final inputFile = File(pdfPath);
    if (!await inputFile.exists()) {
      throw Exception('PDF file not found: $pdfPath');
    }

    final bytes = await inputFile.readAsBytes();

    // Load existing PDF
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    final int pageCount = document.pages.count;

    // Remove existing bookmarks so new ones replace them rather than
    // appending to the existing outline tree.
    try {
      document.bookmarks.clear();
    } catch (_) {
      // If clearing is not supported for some PdfDocument states, ignore
      // and proceed to add bookmarks (best-effort).
    }

    // Map to track created bookmarks keyed by the original TocEntry.index
    final Map<int, PdfBookmark> created = {};

    for (final entry in entries) {
      // Ensure page index within range (Syncfusion uses 0-based index for pages)
      var pageIndex = entry.realPage - 1;
      if (pageIndex < 0) pageIndex = 0;
      if (pageIndex >= pageCount) pageIndex = pageCount - 1;

      // Prepare page destination
      final destination = PdfDestination(document.pages[pageIndex]);

      // Create bookmark either as a child of its parent or at the root.
      // The `add` method on PdfBookmarkBase/PdfBookmark returns a PdfBookmark.
      late final PdfBookmark bm;
      if (entry.parent != null && created.containsKey(entry.parent)) {
        final parentBm = created[entry.parent]!;
        bm = parentBm.add(entry.title);
      } else {
        bm = document.bookmarks.add(entry.title);
      }

      // Attach destination and record the created bookmark
      bm.destination = destination;
      created[entry.index] = bm;
    }

    // Save to new file with _new suffix using package:path to avoid regex issues
    final dir = p.dirname(pdfPath);
    final base = p.basenameWithoutExtension(pdfPath);
    final outPath = p.join(dir, '${base}_new.pdf');

    final List<int> outBytes = await document.save();
    final outFile = File(outPath);
    try {
      await outFile.writeAsBytes(outBytes);
    } finally {
      document.dispose();
    }
    return outPath;
  }

  /// Extract bookmarks (outline) from a PDF file and return formatted text.
  /// Returns a string with the table of contents, where each line represents a bookmark.
  /// Format: "title (page)" with indentation indicating the hierarchy level.
  static Future<String> extractOutline(String pdfPath) async {
    final inputFile = File(pdfPath);
    if (!await inputFile.exists()) {
      throw Exception('PDF file not found: $pdfPath');
    }

    final bytes = await inputFile.readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    try {
      final bookmarks = document.bookmarks;

      final StringBuffer buffer = StringBuffer();

      // Extract bookmark information recursively
      _extractBookmarksRecursive(bookmarks, document, buffer, 0);

      final result = buffer.toString().trimRight();
      return result;
    } finally {
      document.dispose();
    }
  }

  /// Helper method to recursively extract bookmarks
  static void _extractBookmarksRecursive(
    PdfBookmarkBase bookmarks,
    PdfDocument document,
    StringBuffer buffer,
    int level,
  ) {
    for (int i = 0; i < bookmarks.count; i++) {
      final bookmark = bookmarks[i];
      final title = bookmark.title;

      // Get page number from destination
      int pageNum = 0;
      if (bookmark.destination != null) {
        final page = bookmark.destination!.page;
        // Find the page index in the document
        for (int j = 0; j < document.pages.count; j++) {
          if (document.pages[j] == page) {
            pageNum = j + 1; // 1-based page number
            break;
          }
        }
      }

      // Add indentation based on level
      final indent = '  ' * level;

      // Format: "  title (page)" or just "  title" if page is 0
      if (pageNum > 0) {
        buffer.writeln('$indent$title ($pageNum)');
      } else {
        buffer.writeln('$indent$title');
      }
      // Recurse into child bookmarks if any. A PdfBookmark itself acts as
      // a PdfBookmarkBase collection for its children, so pass it directly.
      if (bookmark.count > 0) {
        _extractBookmarksRecursive(bookmark, document, buffer, level + 1);
      }
    }
  }
}
