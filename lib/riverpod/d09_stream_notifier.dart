import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 9. StreamNotifier — stream থেকে আসা ডেটা + নিজের মেথড।
//    "লাইভ কমেন্ট": post 1-এর 5টা কমেন্ট API থেকে এনে প্রতি 2 সেকেন্ডে একটা করে দেখায়,
//    আর আপনি নিজেও কমেন্ট পাঠাতে পারেন (POST /comments)।
//    autoDispose ব্যবহার হয়েছে, তাই ক্লাসটা AutoDisposeStreamNotifier।
// ─────────────────────────────────────────────────────────────

class LiveCommentsNotifier extends AutoDisposeStreamNotifier<List<Comment>> {
  static const postId = 1;
  final _mine = <Comment>[]; // আমার পাঠানো কমেন্ট

  @override
  Stream<List<Comment>> build() {
    _mine.clear();
    final api = ref.watch(apiProvider);
    // Future → Stream: আগে সব কমেন্ট আনো, তারপর একটা একটা করে "লাইভ" ছাড়ো।
    // পেজ বন্ধ হলে (cancel) Stream.periodic নিজেই থেমে যায়।
    return Stream.fromFuture(api.getComments(postId: postId)).asyncExpand(
      (all) => Stream.periodic(
        const Duration(seconds: 2),
        (i) => [...all.take(i + 1), ..._mine],
      ).take(all.length),
    );
  }

  // মেথড থেকে সরাসরি state বসানো যায়
  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    final created = await ref.read(apiProvider).createComment(postId: postId, body: text.trim());
    _mine.add(created);
    state = AsyncData([...?state.valueOrNull, created]);
  }
}

final liveCommentsProvider =
    StreamNotifierProvider.autoDispose<LiveCommentsNotifier, List<Comment>>(
  LiveCommentsNotifier.new,
  name: 'liveCommentsProvider',
);

class StreamNotifierDemoPage extends ConsumerStatefulWidget {
  const StreamNotifierDemoPage({super.key});

  @override
  ConsumerState<StreamNotifierDemoPage> createState() => _StreamNotifierDemoPageState();
}

class _StreamNotifierDemoPageState extends ConsumerState<StreamNotifierDemoPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(liveCommentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('9. StreamNotifier · post 1')),
      body: Column(
        children: [
          Expanded(
            child: comments.when(
              data: (items) => ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final c in items)
                    ListTile(
                      dense: true,
                      leading: Icon(c.email == 'me@example.com' ? Icons.person : Icons.chat_bubble_outline),
                      title: Text(c.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(c.email),
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Comment (POST /comments)'),
              onSubmitted: (text) {
                ref.read(liveCommentsProvider.notifier).send(text);
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
