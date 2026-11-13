import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'json_placeholder_api.dart';

// সব ডেমো এই তিনটা provider দিয়ে API পায় (Dependency Injection)।
// টেস্টে শুধু httpClientProvider override করলেই পুরো অ্যাপ নকল সার্ভারে চলে যায়।

final baseUrlProvider = Provider<String>(
  (ref) => 'https://jsonplaceholder.typicode.com',
  name: 'baseUrlProvider',
);

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close); // provider মুছে গেলে কানেকশন বন্ধ
  return client;
}, name: 'httpClientProvider');

final apiProvider = Provider<JsonPlaceholderApi>((ref) {
  return JsonPlaceholderApi(
    ref.watch(httpClientProvider),
    baseUrl: ref.watch(baseUrlProvider),
  );
}, name: 'apiProvider');
