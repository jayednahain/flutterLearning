import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ProviderObserver: অ্যাপের সব provider-এর জন্ম, বদল, মৃত্যু আর এরর এক জায়গায় দেখা যায়।
/// main.dart-এ ProviderScope(observers: [LoggerObserver()]) দিয়ে চালু করা হয়েছে।
/// Debug Console-এ লগ দেখুন।
class LoggerObserver extends ProviderObserver {
  String _label(ProviderBase<Object?> provider) =>
      provider.name ?? provider.runtimeType.toString();

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint('[ADD]     ${_label(provider)} = $value');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('[UPDATE]  ${_label(provider)}: $previousValue → $newValue');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint('[DISPOSE] ${_label(provider)}');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint('[FAIL]    ${_label(provider)}: $error');
  }
}
