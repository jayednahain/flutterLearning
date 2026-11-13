import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 3. FutureProvider — একবারের async ডেটা: GET /users
//    UI পায় AsyncValue<T>: loading / data / error।
// ─────────────────────────────────────────────────────────────

// চালু করলে ভুল URL-এ রিকোয়েস্ট যায়, আর 404 আসে (error UI দেখার জন্য)
final simulateErrorProvider = StateProvider<bool>((ref) => false, name: 'simulateErrorProvider');

final usersProvider = FutureProvider<List<User>>((ref) async {
  final api = ref.watch(apiProvider);
  final broken = ref.watch(simulateErrorProvider); // এটা বদলালে নিজে থেকে আবার চলবে
  return api.getUsers(simulateError: broken);
}, name: 'usersProvider');

class FutureProviderDemoPage extends ConsumerWidget {
  const FutureProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(usersProvider);
    final broken = ref.watch(simulateErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('3. FutureProvider'),
        actions: [
          IconButton(
            tooltip: 'invalidate',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(usersProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Simulate error (404)'),
            value: broken,
            onChanged: (v) => ref.read(simulateErrorProvider.notifier).state = v,
          ),
          // isRefreshing: refresh বা invalidate-এর কারণে আবার আসছে, আগের ডেটা আছে
          // isReloading: নির্ভরতা (simulateErrorProvider) বদলেছে বলে আবার আসছে
          Text(
            'isLoading: ${asyncUsers.isLoading} · '
            'isRefreshing: ${asyncUsers.isRefreshing} · '
            'isReloading: ${asyncUsers.isReloading}',
          ),
          Expanded(
            // refresh: সাথে সাথে আবার চালায় আর নতুন Future ফেরত দেয়
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(usersProvider.future),
              child: asyncUsers.when(
                skipLoadingOnRefresh: true, // ডিফল্ট: রিফ্রেশে পুরোনো ডেটাই দেখায়
                skipLoadingOnReload: false, // ডিফল্ট: নির্ভরতা বদলালে loading দেখায়
                data: (users) => ListView(
                  children: [
                    for (final user in users)
                      ListTile(
                        leading: CircleAvatar(child: Text('${user.id}')),
                        title: Text(user.name),
                        subtitle: Text('${user.email} · ${user.city}'),
                      ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                // RefreshIndicator কাজ করার জন্য এরর অংশও scrollable রাখা হয়েছে
                error: (error, stackTrace) => ListView(
                  padding: const EdgeInsets.all(32),
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Center(
                      child: FilledButton(
                        onPressed: () => ref.invalidate(usersProvider),
                        child: const Text('Try again'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
