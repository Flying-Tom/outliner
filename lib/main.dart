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
      // Set minimum and maximum sizes to keep layout predictable
      window_size.setWindowMinSize(const ui.Size(800, 600));
      window_size.setWindowMaxSize(const ui.Size(1920, 1080));

      // Set an initial window frame (centered on the primary screen when possible)
      final winInfo = await window_size.getWindowInfo();
      final screenFrame = winInfo.screen?.visibleFrame;
      const initialWidth = 1200.0;
      const initialHeight = 800.0;
      if (screenFrame != null) {
        final left = screenFrame.left + (screenFrame.width - initialWidth) / 2;
        final top = screenFrame.top + (screenFrame.height - initialHeight) / 2;
        window_size.setWindowFrame(
            ui.Rect.fromLTWH(left, top, initialWidth, initialHeight));
      } else {
        window_size.setWindowFrame(
            ui.Rect.fromLTWH(100, 100, initialWidth, initialHeight));
      }
    } catch (e) {
      // ignore errors if window sizing isn't available on the platform
    }
  }

  runApp(const OutlinerApp());
}
