import 'package:outliner/models/toc_entry.dart';

class TocConverter {
  static const List<String> defaultLevelExpressions = [
    r'^\d+\.\s?',
    r'^\d+\.\d+\w?\s?',
    r'^\d+\.\d+\.\d+\w?\s?',
    r'^\d+\.\d+\.\d+\.\d+\w?\s?',
    r'^\d+\.\d+\.\d+\.\d+\.\d+\w?\s?',
    r'^\d+\.\d+\.\d+\.\d+\.\d+\.\d+\w?\s?',
  ];

  static const List<String> _pageNumberPatterns = [
    r'((?<!-)\-?\d+)',
    r'\((\d+)\)',
    r'\[(\d+)\]',
    r'\{(\d+)\}',
    r'<(\d+)>',
    r'（(\d+)）',
    r'【(\d+)】',
    r'「(\d+)」',
    r'《(\d+)》',
    r'(\d*)',
  ];

  static final List<RegExp> _compiledPagePatterns = _pageNumberPatterns
      .map((pattern) => RegExp(r'(.*?)' + pattern + r'$'))
      .toList();

  static TocSplit _splitPageNum(String text) {
    var content = '';
    var number = 1;
    for (final pattern in _compiledPagePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        content = match.group(1) ?? '';
        final numGroup = match.group(2);
        if (numGroup != null && numGroup.isNotEmpty) {
          number = int.tryParse(numGroup) ?? 1;
        }
        break;
      }
    }
    if (content.isNotEmpty) {
      content = content.replaceFirst(RegExp(r'[ .-]+\$'), '');
    }
    return TocSplit(org: content, title: content, number: number);
  }

  static RegExp? _compilePattern(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    try {
      return RegExp(input);
    } catch (_) {
      return null;
    }
  }

  static List<String?> _generateLevelPatternsBySpace(List<String> lines) {
    final whitespace = RegExp(r'^\s*');
    final counts = <int>{};
    for (final line in lines) {
      final match = whitespace.firstMatch(line);
      if (match != null) counts.add(match.group(0)?.length ?? 0);
    }
    final sorted = counts.toList()..sort();
    final patterns = List<String?>.filled(6, null);
    const maxLevel = 5;
    var level = 0;
    while (sorted.isNotEmpty) {
      final count = sorted.removeAt(0);
      if (level > maxLevel) {
        patterns[maxLevel] = r'\s{' + count.toString() + r',}';
        break;
      }
      patterns[level] = r'\s{' + count.toString() + r'}';
      level++;
    }
    return patterns;
  }

  static int _checkLevel(
    String title,
    List<RegExp?> patterns, {
    int other = 0,
  }) {
    for (var idx = patterns.length - 1; idx >= 0; idx--) {
      final regex = patterns[idx];
      if (regex != null && regex.hasMatch(title)) return idx;
    }
    return other;
  }

  static List<TocEntry> convert(
    String text, {
    int offset = 0,
    List<RegExp?>? levelPatterns,
    int other = 0,
    bool levelBySpace = false,
    bool fixNonSeq = false,
    bool trimLines = true,
  }) {
    final originalLines = text.split(RegExp(r'\r?\n'));
    final lines = trimLines
        ? originalLines.map((l) => l.trim()).toList()
        : List<String>.from(originalLines);
    final patterns = levelPatterns ??
        defaultLevelExpressions.map((it) => _compilePattern(it)).toList();

    if (levelBySpace) {
      final spaceSource = originalLines;
      final spacePatterns = _generateLevelPatternsBySpace(spaceSource);
      for (var i = 0; i < patterns.length && i < spacePatterns.length; i++) {
        patterns[i] = _compilePattern(spacePatterns[i]);
      }
    }

    final entries = <TocEntry>[];
    var l0 = 0;
    var l1 = 0;
    var l2 = 0;
    var l3 = 0;
    var l4 = 0;
    var pageNum = -100000;

    for (var i = 0; i < lines.length; i++) {
      final raw = lines[i];
      if (raw.isEmpty) continue;
      final split = _splitPageNum(raw);
      if (split.org.isEmpty && split.number == 1) continue;
      if (split.number > pageNum || !fixNonSeq) pageNum = split.number;
      final level = _checkLevel(split.org, patterns, other: other);
      int? parent;
      switch (level) {
        case 5:
          if (i != l4) parent = l4;
          break;
        case 4:
          if (i != l3) parent = l3;
          l4 = i;
          break;
        case 3:
          if (i != l2) parent = l2;
          l3 = i;
          break;
        case 2:
          if (i != l1) parent = l1;
          l2 = i;
          break;
        case 1:
          if (i != l0) parent = l0;
          l1 = i;
          break;
        default:
          l0 = i;
          break;
      }
      entries.add(
        TocEntry(
          index: i,
          title: split.title.trimLeft(),
          page: split.number,
          realPage: pageNum + offset,
          level: level,
          parent: parent,
        ),
      );
    }
    return entries;
  }
}
