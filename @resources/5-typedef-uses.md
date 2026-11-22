# typedef

Dart-এ `typedef` হলো একটি টপ-লেভেল (Top-level) ডিক্লারেশন। এটি সবসময় `main()` বা ক্লাসের বাইরে (ফাইলের একদম ওপরে বা নিচে) লিখতে হয়।

---

## ১. কোথায় লিখতে হবে

### ❌ ভুল (ফাংশন বা ক্লাসের ভেতরে)

```dart
void main() {
  typedef PriceFormatter = String Function(double amount); // ❌ এখানে এরর দেবে
}
```

### ✅ সঠিক (ফাইলের একদম বাইরে)

```dart
typedef PriceFormatter = String Function(double amount); // ✅ এখানে লিখুন

void main() {
  PriceFormatter format = (amount) => '৳$amount';
  print(format(150.5));
}
```

---

## ২. typedef দিয়ে বনাম typedef ছাড়া

### typedef দিয়ে

```dart
typedef OnButtonClick = void Function(String buttonTitle);

class CustomButton extends StatelessWidget {
  final String title;
  final OnButtonClick onPressed; // কলব্যাক ফাংশন রিসিভ করা হচ্ছে

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // বাটনে ক্লিক হলে প্যারেন্টের দেওয়া ফাংশনটি কল হবে এবং title পাঠাবে
      onPressed: () => onPressed(title),
      child: Text(title),
    );
  }
}
```

### typedef ছাড়া (সরাসরি ফাংশন টাইপ লিখে)

```dart
class CustomButton extends StatelessWidget {
  final String title;
  // এখানে সরাসরি পুরো ফাংশনের সিগনেচার লিখতে হচ্ছে:
  final void Function(String buttonTitle) onPressed;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  // ... বাকি কোড একই
}
```
