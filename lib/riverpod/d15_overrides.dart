import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';
import 'd05_family.dart';

// ─────────────────────────────────────────────────────────────
// 15. Overrides আর scoping
//     • main-এ override: অ্যাপ শুরুর আগে মান বসানো (TWG-র apiClientProvider)
//     • নেস্টেড ProviderScope: উইজেট ট্রির একটা অংশে আলাদা মান
//     • টেস্টে override: আসল জিনিসের জায়গায় নকল (test/riverpod_test.dart দেখুন)
// ─────────────────────────────────────────────────────────────

// 10 জন আলাদা লেখকের 10টা post (id 1, 11, 21, …, 91)
final samplePostsProvider = FutureProvider<List<Post>>((ref) async {
  final all = await ref.watch(apiProvider).getPosts();
  return all.where((p) => p.id % 10 == 1).toList();
}, name: 'samplePostsProvider');

// ডিফল্টভাবে এরর ছোড়ে। মানে "override না করলে ব্যবহার করা যাবে না"।
// নেস্টেড ProviderScope-এ override করতে হলে dependencies দিতে হয়।
final currentPostProvider = Provider<Post>(
  (ref) => throw UnimplementedError('currentPostProvider must be overridden'),
  dependencies: const [],
  name: 'currentPostProvider',
);

// যে provider একটা scoped provider-এর উপর নির্ভর করে, তাকেও সেটা dependencies-এ লিখতে হয়।
// এটা প্রতিটা সারির post-এর লেখককে আনে (GET /users/:id, ডেমো 5-এর userProvider দিয়ে)।
final currentPostAuthorProvider = FutureProvider<User>((ref) {
  final post = ref.watch(currentPostProvider);
  return ref.watch(userProvider(post.userId).future);
}, dependencies: [currentPostProvider], name: 'currentPostAuthorProvider');

class OverridesDemoPage extends ConsumerWidget {
  const OverridesDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(samplePostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('15. Overrides + scoping')),
      body: posts.when(
        data: (items) => ListView(
          children: [
            for (final post in items)
              // প্রতিটা আইটেমের নিজের ProviderScope, নিজের post
              ProviderScope(
                overrides: [currentPostProvider.overrideWithValue(post)],
                child: const _PostTile(),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

// এই উইজেট জানে না কোন post, শুধু currentPostProvider পড়ে।
// ফলে constructor-এ ডেটা পাঠাতে হয় না, আর const রাখা যায়।
class _PostTile extends ConsumerWidget {
  const _PostTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(currentPostProvider);
    final author = ref.watch(currentPostAuthorProvider);
    return ListTile(
      leading: CircleAvatar(child: Text('${post.id}')),
      title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(author.valueOrNull?.name ?? 'loading author…'),
    );
  }
}
