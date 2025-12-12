// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'PDF 书签编辑器';

  @override
  String get pdfInput => '文档与输入';

  @override
  String get configuration => '配置';

  @override
  String get selectPdf => '选择 PDF';

  @override
  String get browsePdf => '浏览 PDF';

  @override
  String get pdfFile => 'PDF 文件';

  @override
  String get tocText => '目录文本';

  @override
  String get tocHint => '在这里粘贴目录文本';

  @override
  String get pageOffset => '页面偏移';

  @override
  String get levelPatterns => '层级模式';

  @override
  String get insertBookmarks => '插入书签';

  @override
  String get previewStatus => '预览与状态';

  @override
  String get status => '状态';

  @override
  String get logs => '日志';

  @override
  String get previewHint => '粘贴目录文本后将显示预览';

  @override
  String get noEntriesParsed => '未能解析出目录条目，请检查格式或正则';

  @override
  String get logsHint => '日志将在此显示';

  @override
  String get choosePdfFirst => '请先选择 PDF 文件';

  @override
  String get pasteDirectoryText => '请先粘贴目录文本';

  @override
  String get pageOffsetMustBeInt => '页面偏移必须是整数';

  @override
  String get invalidRegex => '无效的正则表达式: ';

  @override
  String get addingBookmarks => '正在添加书签...';

  @override
  String get finishedWriting => '完成写入';

  @override
  String get error => '错误: ';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get systemTheme => '系统';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get trimLineWhitespace => '去除每行首尾空格';

  @override
  String get tocHierarchy => '目录分层';

  @override
  String get unrecognized => '【未识别】';

  @override
  String get title => '标题';

  @override
  String get markedPage => '标注页数';

  @override
  String get actualPage => '实际页数';

  @override
  String get extractOutline => '提取目录';

  @override
  String get outlineExtracted => '目录提取成功';

  @override
  String get resetToDefaults => '恢复默认';

  @override
  String get resetDefaultsDone => '已恢复默认';

  @override
  String get saveSettings => '保存';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get noPdfOutline => '该 PDF 中未找到目录';
}
