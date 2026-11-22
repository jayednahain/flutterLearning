import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final name = Provider<String>((ref){
  return "test";
});

final age = Provider<int>((ref){
  return 30;
});

class Helper {
  String getClassName()=> "my class name";
}

class DataBox<T>{
  final T Function(Helper helper) _recipes;
  DataBox(this._recipes);

}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nameSubscribe = ref.watch(name);
    var ageSubscribe = ref.watch(age);
    return Scaffold(
      appBar: AppBar(
          title:Text("my provider app")
      ),
      body: Center(child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
        Text(nameSubscribe),
        Text(ageSubscribe.toString())
      ])),

    );

  }
}
