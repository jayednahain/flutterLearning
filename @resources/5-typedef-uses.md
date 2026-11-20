# Dart-এ typedef হলো একটি টপ-লেভেল (Top-level) ডিক্লারেশন। এটি সবসময় main() বা ক্লাসের বাইরে (ফাইলের একদম ওপরে বা নিচে) লিখতে হয়।

- ভুল (ফাংশন বা ক্লাসের ভেতরে):

```dart
void main() {
  typedef PriceFormatter = String Function(double amount); // ❌ এখানে এরর দেবে
}
```

- সঠিক (ফাইলের একদম বাইরে):

```dart
typedef PriceFormatter = String Function(double amount); // ✅ এখানে লিখুন

void main() {
  PriceFormatter format = (amount) => '৳$amount';
  print(format(150.5));
}
```
