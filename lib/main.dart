import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/logger_observer.dart';
import 'riverpod/d01_provider.dart';
import 'riverpod/d02_state_provider.dart';
import 'riverpod/d03_future_provider.dart';
import 'riverpod/d04_stream_provider.dart';
import 'riverpod/d05_family.dart';
import 'riverpod/d06_auto_dispose.dart';
import 'riverpod/d07_notifier.dart';
import 'riverpod/d08_async_notifier.dart';
import 'riverpod/d09_stream_notifier.dart';
import 'riverpod/d10_family_notifier.dart';
import 'riverpod/d11_state_notifier.dart';
import 'riverpod/d12_change_notifier.dart';
import 'riverpod/d13_consumers.dart';
import 'riverpod/d14_select.dart';
import 'riverpod/d15_overrides.dart';

void main() {
  runApp(
    // ProviderScope: সব provider-এর ঘর। এটা ছাড়া কোনো provider কাজ করবে না।
    ProviderScope(
      observers: [LoggerObserver()],
      child: const PlaygroundApp(),
    ),
  );
}

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const DemoMenuPage(),
    );
  }
}

class _Demo {
  const _Demo(this.title, this.subtitle, this.page);
  final String title;
  final String subtitle;
  final Widget page;
}

const _demos = <_Demo>[
  _Demo('Provider', 'API client বানানো (DI), baseUrl থেকে URL হিসাব', ProviderDemoPage()),
  _Demo('StateProvider', 'সিলেক্টেড post id: .state, update, listen', StateProviderDemoPage()),
  _Demo('FutureProvider', 'GET /users: when, refresh, invalidate, 404', FutureProviderDemoPage()),
  _Demo('StreamProvider', 'ঘড়ি + post polling, stream-এ এরর', StreamProviderDemoPage()),
  _Demo('family', 'post(id), comments(id), পেজিনেশন (record)', FamilyDemoPage()),
  _Demo('autoDispose + lifecycle', 'onDispose, onCancel, keepAlive, users cache', AutoDisposeDemoPage()),
  _Demo('Notifier', 'ফেভারিট post (লোকাল) + API লিস্ট', NotifierDemoPage()),
  _Demo('AsyncNotifier', 'todos CRUD: guard, optimistic, rollback', AsyncNotifierDemoPage()),
  _Demo('StreamNotifier', 'লাইভ কমেন্ট + POST /comments', StreamNotifierDemoPage()),
  _Demo('Family Notifier', 'প্রতিটা post-এর like আর কমেন্ট', FamilyNotifierDemoPage()),
  _Demo('StateNotifier (legacy)', '/users?username= দিয়ে লগইন, TWG-স্টাইল', StateNotifierDemoPage()),
  _Demo('ChangeNotifierProvider (legacy)', 'পুরোনো ChangeNotifier', ChangeNotifierDemoPage()),
  _Demo('Consumer, ConsumerStateful, listenManual', 'কোথায় কোন ref', ConsumersDemoPage()),
  _Demo('select / selectAsync', 'শুধু দরকারি অংশ বদলালে রিবিল্ড', SelectDemoPage()),
  _Demo('Overrides + scoping', 'প্রতিটা post-এর নিজের scope + লেখক', OverridesDemoPage()),
];

class DemoMenuPage extends StatelessWidget {
  const DemoMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Playground')),
      body: ListView.separated(
        itemCount: _demos.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final demo = _demos[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(demo.title),
            subtitle: Text(demo.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => demo.page),
            ),
          );
        },
      ),
    );
  }
}
