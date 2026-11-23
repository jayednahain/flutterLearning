import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = Provider<String>((ref) {
  return "test";
});

final ageProvider = Provider<int>((ref) {
  return 30;
});



