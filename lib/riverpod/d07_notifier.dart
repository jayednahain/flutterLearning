import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 7. Notifier + NotifierProvider — সিঙ্ক স্টেট আর নিজের মেথড।
//    Riverpod 2-এর আধুনিক উপায় (StateNotifier-এর বদলে এটাই সুপারিশ করা হয়)।
//    এখানে: API থেকে post আসে (FutureProvider), আর কোনগুলো ফেভারিট
//    তা থাকে লোকাল Notifier-এ। দুটো মিলিয়ে ফিল্টার করা লিস্ট।
// ─────────────────────────────────────────────────────────────

// GET /posts?_page=1&_limit=20
final firstPostsProvider = FutureProvider<List<Post>>((ref) {
  return ref.watch(apiProvider).getPosts(page: 1, limit: 20);
}, name: 'firstPostsProvider');

class FavoritePostsNotifier extends Notifier<Set<int>> {
  // build(): শুরুর স্টেট। এখানে ref.watch করা যায়, তখন সেটা বদলালে build আবার চলে।
  @override
  Set<int> build() => const {};

  void toggle(int postId) {
    // সবসময় নতুন Set বানিয়ে state-এ বসান, পুরোনোটা বদলাবেন না
    state = state.contains(postId)
        ? {for (final id in state) if (id != postId) id}
        : {...state, postId};
  }

  void clear() => state = const {};
}

// NotifierProvider<NotifierClass, StateType>(NotifierClass.new)
final favoritePostsProvider = NotifierProvider<FavoritePostsNotifier, Set<int>>(
  FavoritePostsNotifier.new,
  name: 'favoritePostsProvider',
);

enum PostFilter { all, favorites }

final postFilterProvider = StateProvider<PostFilter>(
  (ref) => PostFilter.all,
  name: 'postFilterProvider',
);

// AsyncValue (API) + সিঙ্ক স্টেট (ফেভারিট, ফিল্টার) মেলানো।
// whenData: ডেটা থাকলে বদলায়, loading বা error হলে যেমন আছে তেমন রাখে।
final visiblePostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final posts = ref.watch(firstPostsProvider);
  final favorites = ref.watch(favoritePostsProvider);
  final filter = ref.watch(postFilterProvider);
  return posts.whenData(
    (list) => filter == PostFilter.all
        ? list
        : list.where((p) => favorites.contains(p.id)).toList(),
  );
}, name: 'visiblePostsProvider');

final favoriteCountProvider = Provider<int>(
  (ref) => ref.watch(favoritePostsProvider.select((ids) => ids.length)),
  name: 'favoriteCountProvider',
);

class NotifierDemoPage extends ConsumerWidget {
  const NotifierDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(visiblePostsProvider);
    final favorites = ref.watch(favoritePostsProvider);
    final count = ref.watch(favoriteCountProvider);
    final filter = ref.watch(postFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('7. Notifier · ♥ $count'),
        actions: [
          IconButton(
            tooltip: 'Clear favorites',
            icon: const Icon(Icons.clear_all),
            onPressed: () => ref.read(favoritePostsProvider.notifier).clear(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SegmentedButton<PostFilter>(
            segments: const [
              ButtonSegment(value: PostFilter.all, label: Text('All')),
              ButtonSegment(value: PostFilter.favorites, label: Text('Favorites')),
            ],
            selected: {filter},
            onSelectionChanged: (s) => ref.read(postFilterProvider.notifier).state = s.first,
          ),
          Expanded(
            child: posts.when(
              data: (items) => items.isEmpty
                  ? const Center(child: Text('কোনো ফেভারিট নেই'))
                  : ListView(
                      children: [
                        for (final post in items)
                          ListTile(
                            leading: Text('#${post.id}'),
                            title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: IconButton(
                              icon: Icon(
                                favorites.contains(post.id) ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  ref.read(favoritePostsProvider.notifier).toggle(post.id),
                            ),
                          ),
                      ],
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
        ],
      ),
    );
  }
}
