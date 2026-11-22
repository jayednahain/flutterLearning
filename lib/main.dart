import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: Center(
          child: Row(
            children: [
              // ৪. অ্যানোনিমাস ফাংশন পাস করে বাটনটি ব্যবহার করা হচ্ছে
              CustomButton(
                title: 'Login',
                onPressed: (clickedTitle) =>
                    print('$clickedTitle বাটনে ক্লিক হয়েছে!'),
              ),

              const SizedBox(height: 16),

              // একই বাটন দিয়ে সম্পূর্ণ ভিন্ন কাজ করানো হচ্ছে
              CustomButton(
                title: 'Sign Up',
                onPressed: (clickedTitle) {
                  // এখানে নতুন পেজে নেভিগেট করার কোড লিখতে পারেন
                  print('নতুন ইউজার রেজিস্ট্রেশন শুরু হচ্ছে ($clickedTitle)');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef OnButtonClick = void Function(String buttonTitle);

class CustomButton extends StatelessWidget {
  final String title;
  final OnButtonClick onPressed; // ২. কলব্যাক ফাংশন রিসিভ করা হচ্ছে

  const CustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // ৩. বাটনে ক্লিক হলে প্যারেন্টের দেওয়া ফাংশনটি কল হবে এবং title পাঠাবে
      onPressed: () => onPressed(title),
      child: Text(title),
    );
  }
}
