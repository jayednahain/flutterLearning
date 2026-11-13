import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';
import 'd05_family.dart';

// ─────────────────────────────────────────────────────────────
// 10. Family Notifier — প্রতিটা প্যারামিটারের জন্য আলাদা Notifier।
//     Riverpod 2-এ ক্লাসের নাম বদলায়:
//       NotifierProvider.family                 → FamilyNotifier<State, Arg>
//       AsyncNotifierProvider.autoDispose.family → AutoDisposeFamilyAsyncNotifier<State, Arg>
// ─────────────────────────────────────────────────────────────

// প্রতিটা post-এর like সংখ্যা (শুধু লোকাল)
class PostLikesNotifier extends FamilyNotifier<int, int> {
  @override
  int build(int postId) => 0; // প্যারামিটার build-এ আসে, আর পরে `arg` দিয়েও পাওয়া যায়

  void like() => state++;

  void unlike() {
    if (state > 0) state--;
  }
}

final postLikesProvider = NotifierProvider.family<PostLikesNotifier, int, int>(
  PostLikesNotifier.new,
  name: 'postLikesProvider',
);

const demoPostIds = [1, 2, 3];

final totalLikesProvider = Provider<int>((ref) {
  var total = 0;
  for (final id in demoPostIds) {
    total += ref.watch(postLikesProvider(id));
  }
  return total;
}, name: 'totalLikesProvider');

// async + family + autoDispose: প্রতিটা post-এর কমেন্ট (GET), আর নতুন কমেন্ট (POST)
class PostCommentsNotifier extends AutoDisposeFamilyAsyncNotifier<List<Comment>, int> {
  @override
  Future<List<Comment>> build(int postId) {
    return ref.watch(apiProvider).getComments(postId: postId);
  }

  Future<void> addComment(String body) async {
    final created = await ref.read(apiProvider).createComment(postId: arg, body: body);
    await update((comments) => [...comments, created]);
  }
}

final postCommentsNotifierProvider =
    AsyncNotifierProvider.autoDispose.family<PostCommentsNotifier, List<Comment>, int>(
  PostCommentsNotifier.new,
  name: 'postCommentsNotifierProvider',
);

class FamilyNotifierDemoPage extends ConsumerWidget {
  const FamilyNotifierDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(totalLikesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('10. Family Notifier · ♥ $total')),
      body: ListView(
        children: [
          for (final id in demoPostIds) _PostCard(postId: id),
        ],
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  const _PostCard({required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId)); // ডেমো 5-এর family provider
    final likes = ref.watch(postLikesProvider(postId));
    final comments = ref.watch(postCommentsNotifierProvider(postId));
    final likesNotifier = ref.read(postLikesProvider(postId).notifier);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.valueOrNull?.title ?? 'Post #$postId',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                IconButton(onPressed: likesNotifier.unlike, icon: const Icon(Icons.thumb_down_outlined)),
                Text('$likes'),
                IconButton(onPressed: likesNotifier.like, icon: const Icon(Icons.thumb_up_outlined)),
                const Spacer(),
                Text(comments.when(
                  data: (items) => '${items.length} comments',
                  loading: () => 'loading…',
                  error: (e, _) => 'error',
                )),
              ],
            ),
            TextButton(
              onPressed: () => ref
                  .read(postCommentsNotifierProvider(postId).notifier)
                  .addComment('Nice post!'),
              child: const Text('Add comment (POST)'),
            ),
          ],
        ),
      ),
    );
  }
}
