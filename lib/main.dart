import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:outliner/ui/app.dart';
import 'package:window_size/window_size.dart' as window_size;

// Configure desktop window size before runApp on supported platforms.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set a reasonable minimum window size for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    try {
      // Set minimum size to prevent layout breakage
      window_size.setWindowMinSize(const ui.Size(1000, 700));

      // Set initial window size
      window_size.setWindowMaxSize(const ui.Size(1920, 1080));
    } catch (e) {
      // ignore errors if window sizing isn't available on the platform
    }
  }

  runApp(const OutlinerApp());
}
