import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────
// 12. ChangeNotifierProvider (legacy)
//     Flutter-এর পুরোনো ChangeNotifier ক্লাসকে Riverpod-এ আনা।
//     TWG-র AppSessionState এভাবেই আনা হয়েছে।
//     নতুন কোডে ব্যবহার না করাই ভালো, কারণ স্টেট mutable আর notifyListeners ভুলে যাওয়া সহজ।
// ─────────────────────────────────────────────────────────────

class ThemeSettings extends ChangeNotifier {
  bool _dark = false;
  double _fontScale = 1.0;

  bool get dark => _dark;
  double get fontScale => _fontScale;

  void toggleDark() {
    _dark = !_dark;
    notifyListeners(); // এটা না ডাকলে UI আপডেট হবে না
  }

  void setFontScale(double value) {
    _fontScale = value;
    notifyListeners();
  }
}

final themeSettingsProvider = ChangeNotifierProvider<ThemeSettings>(
  (ref) => ThemeSettings(),
  name: 'themeSettingsProvider',
);

class ChangeNotifierDemoPage extends ConsumerWidget {
  const ChangeNotifierDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch করলে পুরো ChangeNotifier অবজেক্ট পাওয়া যায়
    final settings = ref.watch(themeSettingsProvider);

    return Theme(
      data: settings.dark ? ThemeData.dark() : ThemeData.light(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('12. ChangeNotifierProvider')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('Dark mode'),
                value: settings.dark,
                // মেথড ডাকতে read, আর .notifier লাগে না
                onChanged: (_) => ref.read(themeSettingsProvider).toggleDark(),
              ),
              Text('Font scale: ${settings.fontScale.toStringAsFixed(1)}'),
              Slider(
                min: 0.8,
                max: 1.6,
                value: settings.fontScale,
                onChanged: (v) => ref.read(themeSettingsProvider).setFontScale(v),
              ),
              Text(
                'Preview text',
                textScaler: TextScaler.linear(settings.fontScale),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
