import 'package:eaglerides/pages/loadingPage/loading.dart';
import 'package:flutter/material.dart';

import '../main.dart';
// import 'package:lottie/lottie.dart';

class GlobalLoader {
  static final GlobalLoader _instance = GlobalLoader._internal();
  factory GlobalLoader() => _instance;
  GlobalLoader._internal();

  OverlayEntry? _overlayEntry;

  void show({String? lottieAssetPath}) {
    if (_overlayEntry != null) return; // Prevent showing multiple loaders

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: Loading(),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

// Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
