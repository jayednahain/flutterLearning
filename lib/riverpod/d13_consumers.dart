import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────
// 13. উইজেটে ref পাওয়ার তিন উপায়, আর listenManual
//     • ConsumerWidget         → StatelessWidget-এর বদলে
//     • ConsumerStatefulWidget → StatefulWidget-এর বদলে (ref পুরো State-এ পাওয়া যায়)
//     • Consumer               → বড় উইজেটের শুধু ছোট একটা অংশ রিবিল্ড করতে
// ─────────────────────────────────────────────────────────────

final likesProvider = StateProvider<int>((ref) => 0, name: 'likesProvider');

class ConsumersDemoPage extends ConsumerStatefulWidget {
  const ConsumersDemoPage({super.key});

  @override
  ConsumerState<ConsumersDemoPage> createState() => _ConsumersDemoPageState();
}

class _ConsumersDemoPageState extends ConsumerState<ConsumersDemoPage> {
  int _pageBuilds = 0;
  final _log = <String>[];
  late final ProviderSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();
    // initState-এ ref.watch বা ref.listen চলে না, কিন্তু ref.read আর ref.listenManual চলে।
    // listenManual একটা subscription ফেরত দেয়, dispose-এ বন্ধ করতে হয়।
    _subscription = ref.listenManual<int>(
      likesProvider,
      (previous, next) => setState(() => _log.insert(0, 'likes: $previous → $next')),
      fireImmediately: true, // শুরুতেই একবার চালাও
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageBuilds++; // লক্ষ করুন: like চাপলেও এটা শুধু listenManual-এর setState-এর জন্য বাড়ে

    return Scaffold(
      appBar: AppBar(title: const Text('13. Consumers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('পুরো পেজ build হয়েছে: $_pageBuilds বার'),
          const SizedBox(height: 16),
          // Consumer: শুধু এই অংশ likes বদলালে রিবিল্ড হয়
          Consumer(
            builder: (context, ref, child) {
              final likes = ref.watch(likesProvider);
              return Row(children: [child!, const SizedBox(width: 8), Text('$likes')]);
            },
            // child: যে অংশ বদলায় না, সেটা এখানে দিন। এটা রিবিল্ড হয় না।
            child: const Icon(Icons.favorite, color: Colors.red),
          ),
          const SizedBox(height: 8),
          FilledButton(
            // callback-এ সবসময় ref.read
            onPressed: () => ref.read(likesProvider.notifier).state++,
            child: const Text('Like'),
          ),
          const Divider(height: 32),
          const Text('listenManual লগ:'),
          for (final line in _log) Text(line),
        ],
      ),
    );
  }
}
