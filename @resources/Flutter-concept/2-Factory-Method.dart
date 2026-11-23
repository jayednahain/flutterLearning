- Factory Method হলো এমন একটি method, যার কাজ হলো কোনো object তৈরি করে return করা।
```dart
class SimCard {
  final String operatorName;

  SimCard(this.operatorName);
}

SimCard createSimCard() {
  return SimCard("GrameenPhone");
}
```
এখানে createSimCard() একটি Factory Method।

কারণ এটি নিজে object তৈরি করছে এবং সেই object return করছে।

```dart
final sim = createSimCard();
```
অর্থাৎ, object তৈরির দায়িত্ব আলাদা একটি method-কে দেওয়া হয়েছে।


```dart
class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```
createState() মেথডটি কী করছে? এটি একটি Factory Method। যখনই Flutter স্ক্রিনে TestWidget দেখায়, সে সাথে সাথে createState() মেথডটি কল করে এবং বলে: "এই উইজেটটিকে নিয়ন্ত্রণ করার জন্য ভেতরের আসল কারিগর (_TestWidgetState) তৈরি করে দাও।"