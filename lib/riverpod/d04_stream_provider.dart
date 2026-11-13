import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 4. StreamProvider — সময়ের সাথে বারবার নতুন মান আসে
//    (ঘড়ি, WebSocket, polling)। UI পায় AsyncValue<T>।
// ─────────────────────────────────────────────────────────────

final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
}, name: 'clockProvider');

// Polling: প্রতি 3 সেকেন্ডে একটা post আনে। 97, 98, 99, 100, তারপর 101।
// 101 নম্বর post নেই, তাই 404 আসে (AsyncError)। এরপর আবার 1 থেকে শুরু হয়, আর ঠিক হয়ে যায়।
final postTickerProvider = StreamProvider.autoDispose<Post>((ref) {
  final api = ref.watch(apiProvider);
  final controller = StreamController<Post>();
  var nextId = 97;

  Future<void> fetchNext() async {
    final id = nextId;
    nextId = id >= 101 ? 1 : id + 1;
    try {
      final post = await api.getPost(id);
      if (!controller.isClosed) controller.add(post);
    } catch (error, stackTrace) {
      if (!controller.isClosed) controller.addError(error, stackTrace);
    }
  }

  unawaited(fetchNext()); // শুরুতেই একবার
  final timer = Timer.periodic(const Duration(seconds: 3), (_) => fetchNext());

  // পেজ বন্ধ হলে টাইমার আর stream দুটোই বন্ধ
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });
  return controller.stream;
}, name: 'postTickerProvider');

String _two(int n) => n.toString().padLeft(2, '0');

class StreamProviderDemoPage extends ConsumerWidget {
  const StreamProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(clockProvider);
    final ticker = ref.watch(postTickerProvider);

    // উপায় ১: Dart 3 pattern matching (AsyncValue একটা sealed class)
    final clockText = switch (clock) {
      AsyncData(:final value) =>
        '${_two(value.hour)}:${_two(value.minute)}:${_two(value.second)}',
      AsyncError(:final error) => 'Error: $error',
      _ => 'Loading…',
    };

    // উপায় ২: getter দিয়ে আলাদা আলাদা অবস্থা দেখা
    final lastPost = ticker.valueOrNull; // এরর হলেও আগের মান থাকে

    return Scaffold(
      appBar: AppBar(title: const Text('4. StreamProvider')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Clock', style: Theme.of(context).textTheme.titleMedium),
          Text(clockText, style: Theme.of(context).textTheme.displaySmall),
          const Divider(height: 48),
          Text('Post ticker (every 3s)', style: Theme.of(context).textTheme.titleMedium),
          Text('isLoading: ${ticker.isLoading}'),
          Text('hasValue: ${ticker.hasValue}'),
          Text('hasError: ${ticker.hasError}'),
          if (ticker.hasError)
            Text('error: ${ticker.error}', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          if (lastPost != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${lastPost.id}')),
                title: Text(lastPost.title),
                subtitle: Text('valueOrNull থেকে · user ${lastPost.userId}'),
              ),
            ),
        ],
      ),
    );
  }
}
