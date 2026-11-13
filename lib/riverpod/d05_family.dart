import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';
import 'd02_state_provider.dart';

// ─────────────────────────────────────────────────────────────
// 5. .family — প্যারামিটারসহ provider।
//    প্রতিটা আলাদা প্যারামিটারের জন্য আলাদা instance আর আলাদা cache থাকে।
// ─────────────────────────────────────────────────────────────

// GET /posts/:id
final postProvider = FutureProvider.autoDispose.family<Post, int>((ref, id) {
  return ref.watch(apiProvider).getPost(id);
}, name: 'postProvider');

// GET /posts/:id/comments
final postCommentsProvider = FutureProvider.autoDispose.family<List<Comment>, int>((ref, postId) {
  return ref.watch(apiProvider).getComments(postId: postId);
}, name: 'postCommentsProvider');

// GET /users/:id। autoDispose নেই, তাই একবার আনা ইউজার cache-এ থাকে (ডেমো 14, 15-ও ব্যবহার করে)
final userProvider = FutureProvider.family<User, int>((ref, id) {
  return ref.watch(apiProvider).getUser(id);
}, name: 'userProvider');

// একাধিক প্যারামিটার: Dart record (রেকর্ডের মান মিললেই একই key ধরা হয়)
// GET /posts?userId=1&_page=2&_limit=5
typedef UserPostsArgs = ({int userId, int page});

final userPostsPageProvider =
    FutureProvider.autoDispose.family<List<Post>, UserPostsArgs>((ref, args) {
  return ref.watch(apiProvider).getPosts(userId: args.userId, page: args.page, limit: 5);
}, name: 'userPostsPageProvider');

class FamilyDemoPage extends ConsumerStatefulWidget {
  const FamilyDemoPage({super.key});

  @override
  ConsumerState<FamilyDemoPage> createState() => _FamilyDemoPageState();
}

class _FamilyDemoPageState extends ConsumerState<FamilyDemoPage> {
  int _userId = 1;
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    // id আসছে ডেমো 2-এর StateProvider থেকে
    final postId = ref.watch(selectedPostIdProvider);
    final post = ref.watch(postProvider(postId));
    final comments = ref.watch(postCommentsProvider(postId));
    final userPosts = ref.watch(userPostsPageProvider((userId: _userId, page: _page)));

    return Scaffold(
      appBar: AppBar(title: const Text('5. family')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('postProvider(id) + postCommentsProvider(id)',
              style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children: [
              for (final id in const [1, 2, 3, 50, 100, 101])
                ChoiceChip(
                  label: Text(id == 101 ? '#101 (নেই)' : '#$id'),
                  selected: postId == id,
                  onSelected: (_) => ref.read(selectedPostIdProvider.notifier).state = id,
                ),
            ],
          ),
          post.when(
            data: (p) => ListTile(
              title: Text(p.title),
              subtitle: Text(p.body),
              trailing: Text('${comments.valueOrNull?.length ?? '…'} comments'),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e', style: const TextStyle(color: Colors.red)),
          ),
          if (post.valueOrNull case final p?) _AuthorLine(userId: p.userId),
          const Divider(height: 32),
          Text('userPostsPageProvider((userId, page))',
              style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              DropdownButton<int>(
                value: _userId,
                items: [
                  for (var id = 1; id <= 10; id++)
                    DropdownMenuItem(value: id, child: Text('User $id')),
                ],
                onChanged: (v) => setState(() {
                  _userId = v ?? 1;
                  _page = 1;
                }),
              ),
              const Spacer(),
              IconButton(
                onPressed: _page > 1 ? () => setState(() => _page--) : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Page $_page / 2'),
              IconButton(
                onPressed: _page < 2 ? () => setState(() => _page++) : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          ...userPosts.when(
            data: (items) => [
              for (final p in items) ListTile(dense: true, leading: Text('#${p.id}'), title: Text(p.title)),
            ],
            loading: () => [const LinearProgressIndicator()],
            error: (e, _) => [Text('$e')],
          ),
        ],
      ),
    );
  }
}

// ছোট আলাদা উইজেট: শুধু এই অংশ userProvider(userId) watch করে
class _AuthorLine extends ConsumerWidget {
  const _AuthorLine({required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(userProvider(userId));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        author.when(
          data: (u) => 'by ${u.name} (@${u.username})',
          loading: () => 'loading author…',
          error: (e, _) => 'author error: $e',
        ),
      ),
    );
  }
}
