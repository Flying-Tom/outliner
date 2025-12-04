class TocEntry {
  TocEntry({
    required this.index,
    required this.title,
    required this.page,
    required this.realPage,
    required this.level,
    this.parent,
  });

  final int index;
  final String title;
  final int page;
  final int realPage;
  final int level;
  final int? parent;
}

class TocSplit {
  TocSplit({required this.org, required this.title, required this.number});

  final String org;
  final String title;
  final int number;
}
