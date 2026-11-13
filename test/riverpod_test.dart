import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning/core/api/api_providers.dart';
import 'package:flutter_learning/core/api/json_placeholder_api.dart';
import 'package:flutter_learning/riverpod/d02_state_provider.dart';
import 'package:flutter_learning/riverpod/d03_future_provider.dart';
import 'package:flutter_learning/riverpod/d05_family.dart';
import 'package:flutter_learning/riverpod/d07_notifier.dart';
import 'package:flutter_learning/riverpod/d08_async_notifier.dart';
import 'package:flutter_learning/riverpod/d10_family_notifier.dart';
import 'package:flutter_learning/riverpod/d11_state_notifier.dart';

import 'fake_json_placeholder.dart';

// ProviderContainer: উইজেট ছাড়াই provider চালানোর জায়গা।
// httpClientProvider override করায় সব API কল নকল সার্ভারে যায়, ইন্টারনেট লাগে না।
ProviderContainer makeContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer(
    overrides: [
      httpClientProvider.overrideWithValue(fakeJsonPlaceholder()),
      ...overrides,
    ],
  );
  addTearDown(container.dispose); // টেস্ট শেষে পরিষ্কার
  return container;
}

void main() {
  test('StateProvider + derived Provider', () {
    final c = makeContainer();
    expect(c.read(selectedPostIdProvider), 1);

    c.read(selectedPostIdProvider.notifier).state = 42;
    expect(c.read(selectedPostUrlProvider), 'https://jsonplaceholder.typicode.com/posts/42');
  });

  test('container.listen records every change', () {
    final c = makeContainer();
    final seen = <int>[];
    c.listen<int>(selectedPostIdProvider, (prev, next) => seen.add(next), fireImmediately: true);

    c.read(selectedPostIdProvider.notifier).state = 5;
    c.read(selectedPostIdProvider.notifier).update((s) => s * 2);
    expect(seen, [1, 5, 10]);
  });

  test('FutureProvider: await .future', () async {
    final c = makeContainer();
    final users = await c.read(usersProvider.future);
    expect(users, hasLength(10));
    expect(users.first.city, 'City 1');
  });

  test('FutureProvider: dependency change → error (404)', () async {
    final c = makeContainer();
    c.read(simulateErrorProvider.notifier).state = true;
    await expectLater(
      c.read(usersProvider.future),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
    );
  });

  test('family with record: pagination', () async {
    final c = makeContainer();
    // autoDispose provider: listen করে বাঁচিয়ে রাখতে হয়, নইলে await-এর মধ্যে মুছে যেতে পারে
    final sub = c.listen(userPostsPageProvider((userId: 1, page: 2)).future, (_, _) {});
    final page2 = await sub.read();
    expect(page2.map((p) => p.id), [6, 7, 8, 9, 10]);
  });

  test('Notifier + whenData: favorites filter', () async {
    final c = makeContainer();
    await c.read(firstPostsProvider.future);
    c.read(favoritePostsProvider.notifier).toggle(3);
    c.read(favoritePostsProvider.notifier).toggle(7);
    c.read(postFilterProvider.notifier).state = PostFilter.favorites;

    expect(c.read(visiblePostsProvider).requireValue.map((p) => p.id), [3, 7]);
    expect(c.read(favoriteCountProvider), 2);
  });

  test('AsyncNotifier: add, optimistic toggle with rollback, remove', () async {
    final c = makeContainer();
    final notifier = c.read(userTodosProvider.notifier);
    expect(await c.read(userTodosProvider.future), hasLength(20));

    await notifier.add('Learn Riverpod');
    final added = c.read(userTodosProvider).requireValue.last;
    expect(added.id, 201);

    // সার্ভারে আছে (id 1): PUT সফল, টিক থেকে যায়
    await notifier.toggle(c.read(userTodosProvider).requireValue.first);
    expect(c.read(userTodosProvider).requireValue.first.completed, isTrue);

    // শুধু লোকাল (id 201): PUT 404, আগের অবস্থায় ফেরে আর exception ছোড়ে
    await expectLater(notifier.toggle(added), throwsA(isA<ApiException>()));
    expect(c.read(userTodosProvider).requireValue.last.completed, isFalse);

    await notifier.remove(201);
    expect(c.read(userTodosProvider).requireValue, hasLength(20));
  });

  test('family Notifier: each post has its own likes', () {
    final c = makeContainer();
    c.read(postLikesProvider(1).notifier).like();
    c.read(postLikesProvider(1).notifier).like();
    c.read(postLikesProvider(2).notifier).like();

    expect(c.read(postLikesProvider(1)), 2);
    expect(c.read(postLikesProvider(3)), 0);
    expect(c.read(totalLikesProvider), 3);
  });

  test('StateNotifier: login with /users?username=', () async {
    final c = makeContainer();
    final login = c.read(loginProvider.notifier);

    expect(await login.login('nobody', '1234'), isFalse);
    expect(await login.login('Bret', 'wrong'), isFalse);
    expect(c.read(loginProvider).error, contains('Wrong password'));

    expect(await login.login('Bret', '1234'), isTrue);
    expect(c.read(loginProvider).user?.name, 'User 1');
  });

  testWidgets('widget test: page with ProviderScope override', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [httpClientProvider.overrideWithValue(fakeJsonPlaceholder())],
        child: const MaterialApp(home: FutureProviderDemoPage()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // প্রথমে loading

    await tester.pumpAndSettle();
    expect(find.text('User 1'), findsOneWidget); // তারপর নকল সার্ভারের ডেটা
  });
}
