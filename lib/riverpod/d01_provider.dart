import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';

// ─────────────────────────────────────────────────────────────
// 1. Provider — শুধু পড়ার মান (read-only)
//    কাজে লাগে: constant (baseUrlProvider), অবজেক্ট বানানো বা DI
//    (httpClientProvider, apiProvider), আর অন্য provider থেকে হিসাব।
//    প্রথম তিনটা আছে lib/core/api/api_providers.dart-এ, কারণ সব ডেমো সেগুলো ব্যবহার করে।
// ─────────────────────────────────────────────────────────────

const jsonPlaceholderResources = ['posts', 'comments', 'users', 'todos', 'albums', 'photos'];

// Computed: baseUrlProvider বদলালে এটা নিজে থেকেই আবার হিসাব হবে
final resourceUrlsProvider = Provider<List<String>>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return [for (final r in jsonPlaceholderResources) '$baseUrl/$r'];
}, name: 'resourceUrlsProvider');

// ConsumerWidget = StatelessWidget + WidgetRef
class ProviderDemoPage extends ConsumerWidget {
  const ProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: মান নেয়, আর মান বদলালে এই উইজেট আবার build হয়
    final api = ref.watch(apiProvider);
    final urls = ref.watch(resourceUrlsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('1. Provider')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('apiProvider → ${api.runtimeType}', style: Theme.of(context).textTheme.titleMedium),
          Text('baseUrl: ${api.baseUrl}'),
          const Divider(height: 32),
          Text('resourceUrlsProvider (computed)', style: Theme.of(context).textTheme.titleMedium),
          for (final url in urls) ListTile(dense: true, title: Text(url)),
        ],
      ),
    );
  }
}
