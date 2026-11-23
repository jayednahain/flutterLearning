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