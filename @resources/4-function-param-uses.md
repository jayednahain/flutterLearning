# Dart-এ একই ফাংশনে Optional Positional Parameter ([]) এবং Named Parameter ({}) একসাথে ব্যবহার করা যায় না। আপনি যেকোনো একটি ব্যবহার করতে পারবেন।

1. সবগুলো Named Parameter ({}) হিসেবে রাখতে চাইলে (Flutter-এ এটাই সবচেয়ে বেশি ব্যবহৃত হয়):

```dart
void testOptional(int a, {String? b, dynamic name}) {
  // কল করার নিয়ম: testOptional(10, b: 'Hello', name: 'Rahim');
}
```

2. সবগুলো Optional Positional Parameter ([]) হিসেবে রাখতে চাইলে:

```dart
void testOptional(int a, [String? b, dynamic name]) {
  // কল করার নিয়ম: testOptional(10, 'Hello', 'Rahim');
}
```

# uses

- প্যারামিটার বেশি হলে বা কোড পরিষ্কার রাখতে চাইলে ➡️ {} (Named) ব্যবহার করুন।

- প্যারামিটার ১-২টি হলে এবং নাম লেখার ঝামেলা এড়াতে চাইলে ➡️ [] (Positional) ব্যবহার করুন।
