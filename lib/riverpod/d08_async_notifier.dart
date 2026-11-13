import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 8. AsyncNotifier + AsyncNotifierProvider — async ডেটা + নিজের মেথড।
//    FutureProvider-এর মতো লোড হয়, আবার Notifier-এর মতো মেথড দিয়ে বদলানো যায়।
//    API-ভিত্তিক বেশিরভাগ স্ক্রিনের জন্য এটাই সবচেয়ে উপযুক্ত।
//
//    JSONPlaceholder আসলে কিছু সেভ করে না। তাই:
//    • নতুন todo: POST সফল হয় (id 201), আমরা লোকাল লিস্টে যোগ করি
//    • নতুন todo-তে টিক (PUT /todos/201) → 404, কারণ সার্ভারে নেই।
//      এটাই optimistic update আর rollback দেখানোর আসল উদাহরণ।
//    • Reload দিলে আবার সার্ভারের 20টা todo ফিরে আসে
// ─────────────────────────────────────────────────────────────

class UserTodosNotifier extends AsyncNotifier<List<Todo>> {
  static const userId = 1;

  // build(): শুরুর ডেটা লোড। চলার সময় state = AsyncLoading, শেষে AsyncData বা AsyncError।
  @override
  Future<List<Todo>> build() {
    return ref.watch(apiProvider).getTodos(userId: userId);
  }

  // প্যাটার্ন ১: loading দেখাও কিন্তু আগের লিস্ট রাখো (copyWithPrevious),
  // তারপর AsyncValue.guard (try/catch নিজে থেকেই করে)
  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final api = ref.read(apiProvider); // মেথডে সবসময় ref.read
    final current = state.valueOrNull ?? const <Todo>[];

    state = const AsyncLoading<List<Todo>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final created = await api.createTodo(userId: userId, title: title.trim());
      // সার্ভার সবসময় id 201 দেয়, তাই লোকাল লিস্টে ইউনিক id বানাই (201, 202, …)
      final maxId = current.fold<int>(200, (m, t) => t.id > m ? t.id : m);
      return [...current, created.copyWith(id: maxId + 1)];
    });
  }

  // প্যাটার্ন ২: optimistic update। আগে UI বদলাও, সার্ভার ব্যর্থ হলে আগের অবস্থায় ফেরাও।
  Future<void> toggle(Todo todo) async {
    final before = state;
    final updated = todo.copyWith(completed: !todo.completed);
    state = AsyncData([
      for (final t in state.requireValue) t.id == todo.id ? updated : t,
    ]);
    try {
      await ref.read(apiProvider).updateTodo(updated);
    } catch (_) {
      state = before; // rollback
      rethrow; // UI-কে জানাও, যাতে SnackBar দেখাতে পারে
    }
  }

  // প্যাটার্ন ৩: update(): বর্তমান ডেটা নিয়ে নতুন ডেটা বানানো
  Future<void> remove(int id) async {
    await ref.read(apiProvider).deleteTodo(id);
    await update((todos) => todos.where((t) => t.id != id).toList());
  }

  // প্যাটার্ন ৪: নিজেকে invalidate করো, তারপর নতুন build শেষ হওয়া পর্যন্ত অপেক্ষা (future)
  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

final userTodosProvider = AsyncNotifierProvider<UserTodosNotifier, List<Todo>>(
  UserTodosNotifier.new,
  name: 'userTodosProvider',
);

class AsyncNotifierDemoPage extends ConsumerStatefulWidget {
  const AsyncNotifierDemoPage({super.key});

  @override
  ConsumerState<AsyncNotifierDemoPage> createState() => _AsyncNotifierDemoPageState();
}

class _AsyncNotifierDemoPageState extends ConsumerState<AsyncNotifierDemoPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
  }

  Future<void> _toggle(Todo todo) async {
    try {
      await ref.read(userTodosProvider.notifier).toggle(todo);
    } catch (e) {
      if (!mounted) return; // await-এর পর পেজ বন্ধ হয়ে গেলে আর কিছু না
      _showError('$e: সার্ভারে নেই, তাই আগের অবস্থায় ফেরানো হলো');
    }
  }

  @override
  Widget build(BuildContext context) {
    // guard থেকে আসা এরর state-এ থাকে, তাই ref.listen দিয়ে SnackBar
    ref.listen<AsyncValue<List<Todo>>>(userTodosProvider, (previous, next) {
      if (next is AsyncError) _showError(next.error!);
    });

    final todos = ref.watch(userTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('8. AsyncNotifier · /todos?userId=1'),
        actions: [
          IconButton(
            tooltip: 'Reload from server',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(userTodosProvider.notifier).reload(),
          ),
        ],
      ),
      body: Column(
        children: [
          // copyWithPrevious-এর কারণে loading-এর সময়ও লিস্ট থাকে, উপরে শুধু একটা দাগ
          if (todos.isLoading && todos.hasValue) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'New todo (POST /todos)'),
              onSubmitted: (text) {
                ref.read(userTodosProvider.notifier).add(text);
                _controller.clear();
              },
            ),
          ),
          Expanded(
            child: todos.when(
              data: (items) => ListView(
                children: [
                  for (final todo in items.reversed)
                    CheckboxListTile(
                      value: todo.completed,
                      onChanged: (_) => _toggle(todo),
                      title: Text(todo.title),
                      subtitle: Text('id ${todo.id}${todo.id > 200 ? ' · শুধু লোকাল' : ''}'),
                      secondary: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref.read(userTodosProvider.notifier).remove(todo.id),
                      ),
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: FilledButton(
                  onPressed: () => ref.read(userTodosProvider.notifier).reload(),
                  child: const Text('Reload'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
