import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 6. autoDispose আর lifecycle
//    autoDispose: কেউ আর watch না করলে provider মুছে যায় (মেমোরি খালি হয়)।
//    ref.onDispose / onCancel / onResume / keepAlive দিয়ে lifecycle নিয়ন্ত্রণ।
// ─────────────────────────────────────────────────────────────

final tickerProvider = StreamProvider.autoDispose<int>((ref) {
  debugPrint('[tickerProvider] created');
  ref.onCancel(() => debugPrint('[tickerProvider] onCancel: শেষ listener চলে গেল'));
  ref.onResume(() => debugPrint('[tickerProvider] onResume: listener আবার এসেছে'));
  ref.onDispose(() => debugPrint('[tickerProvider] onDispose: মুছে গেল'));
  return Stream.periodic(const Duration(seconds: 1), (i) => i);
}, name: 'tickerProvider');

/// নিজের বানানো সহায়ক: autoDispose provider-কে শেষ listener চলে যাওয়ার পর
/// আরও [duration] সময় cache-এ রাখে। এই সময়ের মধ্যে কেউ ফিরলে আবার API কল হয় না।
extension CacheForExtension on Ref<Object?> {
  void cacheFor(Duration duration) {
    final link = keepAlive(); // এখন থেকে আর নিজে মুছবে না
    Timer? timer;
    onCancel(() => timer = Timer(duration, link.close)); // সময় শেষে মুছতে দাও
    onResume(() => timer?.cancel()); // কেউ ফিরলে টাইমার বাতিল
    onDispose(() => timer?.cancel());
  }
}

// GET /users, সাথে কখন আনা হয়েছে (record দিয়ে দুটো মান একসাথে)
final cachedUsersProvider =
    FutureProvider.autoDispose<({List<User> users, DateTime fetchedAt})>((ref) async {
  ref.cacheFor(const Duration(seconds: 10));
  final users = await ref.watch(apiProvider).getUsers();
  return (users: users, fetchedAt: DateTime.now());
}, name: 'cachedUsersProvider');

class AutoDisposeDemoPage extends ConsumerWidget {
  const AutoDisposeDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.exists: provider এখন বেঁচে আছে কিনা (watch না করেই দেখা)
    final tickerAlive = ref.exists(tickerProvider);
    final usersAlive = ref.exists(cachedUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('6. autoDispose + lifecycle')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Debug Console খোলা রেখে নিচের পেজগুলো খুলুন আর বন্ধ করুন।'),
          const SizedBox(height: 12),
          Text('tickerProvider alive: $tickerAlive'),
          Text('cachedUsersProvider alive: $usersAlive'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => const _TickerPage(),
            )),
            child: const Text('Open ticker page'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => const _CachedUsersPage(),
            )),
            child: const Text('Open users (10s cache)'),
          ),
        ],
      ),
    );
  }
}

class _TickerPage extends ConsumerWidget {
  const _TickerPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(tickerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Ticker')),
      body: Center(
        child: Text(
          'Seconds: ${tick.valueOrNull ?? '-'}\n\nপেছনে গেলেই provider মুছে যাবে।\nআবার খুললে 0 থেকে শুরু।',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CachedUsersPage extends ConsumerWidget {
  const _CachedUsersPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(cachedUsersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cached users')),
      body: result.when(
        data: (r) {
          final t = r.fetchedAt;
          return ListView(
            children: [
              ListTile(
                title: Text('Fetched at ${t.hour}:${t.minute}:${t.second}'),
                subtitle: const Text(
                  'বন্ধ করে 10 সেকেন্ডের মধ্যে আবার খুলুন: একই সময় দেখাবে, API কল হবে না।\n'
                  '10 সেকেন্ড পরে খুললে নতুন করে লোড হবে।',
                ),
              ),
              for (final u in r.users) ListTile(dense: true, title: Text(u.name)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
