import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final name = ref.watch(nameProvider);
    final age = ref.watch(ageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("my provider app")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name),
            Text(age.toString()),
          ],
        ),
      ),
    );
  }
}


// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var nameSubscribe = ref.watch(name);
//     var ageSubscribe = ref.watch(age);
//     return Scaffold(
//       appBar: AppBar(
//           title:Text("my provider app")
//       ),
//       body: Center(child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:[
//             Text(nameSubscribe),
//             Text(ageSubscribe.toString())
//           ])),
//
//     );
//
//   }
// }





