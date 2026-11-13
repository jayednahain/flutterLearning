import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';

// ─────────────────────────────────────────────────────────────
// 2. StateProvider — বাইরে থেকে বদলানো যায় এমন ছোট মান
//    (int, bool, String, enum)। জটিল লজিক হলে Notifier নিন (ডেমো 7)।
//    এই selectedPostIdProvider ডেমো 5-ও ব্যবহার করে। মানে এক পেজে বদলালে
//    অন্য পেজেও সেই মান থাকে (গ্লোবাল স্টেট)।
// ─────────────────────────────────────────────────────────────

final selectedPostIdProvider = StateProvider<int>((ref) => 1, name: 'selectedPostIdProvider');

// StateProvider থেকে হিসাব করা মান
final selectedPostUrlProvider = Provider<String>((ref) {
  final id = ref.watch(selectedPostIdProvider);
  return '${ref.watch(baseUrlProvider)}/posts/$id';
}, name: 'selectedPostUrlProvider');

class StateProviderDemoPage extends ConsumerWidget {
  const StateProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen: মান বদলালে একটা কাজ (SnackBar, নেভিগেশন)। নিজে রিবিল্ড করে না।
    ref.listen<int>(selectedPostIdProvider, (previous, next) {
      if (next % 10 == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post $previous → $next: দশের গুণিতক!')),
        );
      }
    });

    final id = ref.watch(selectedPostIdProvider);
    final url = ref.watch(selectedPostUrlProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('2. StateProvider')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selected post id'),
            Text('$id', style: Theme.of(context).textTheme.displayLarge),
            SelectableText(url),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: [
                // update: আগের মান দেখে নতুন মান (JSONPlaceholder-এ post 1 থেকে 100)
                FilledButton(
                  onPressed: () => ref
                      .read(selectedPostIdProvider.notifier)
                      .update((s) => s >= 100 ? 100 : s + 1),
                  child: const Text('+1'),
                ),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.read(selectedPostIdProvider.notifier).update((s) => s <= 1 ? 1 : s - 1),
                  child: const Text('-1'),
                ),
                // .state দিয়ে সরাসরি বসানো
                OutlinedButton(
                  onPressed: () => ref.read(selectedPostIdProvider.notifier).state = 50,
                  child: const Text('Go to 50'),
                ),
                // invalidate: provider ফেলে দাও, আবার শুরুর মান (1) থেকে
                TextButton(
                  onPressed: () => ref.invalidate(selectedPostIdProvider),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('এই id নিয়ে ডেমো 5 খুলুন: সেখানে এই post-টাই দেখাবে।'),
          ],
        ),
      ),
    );
  }
}
