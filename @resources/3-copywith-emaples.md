```dart
void main() {
  Person peronObj = Person(name: "jayed Nahian", age: 10);
  print("name :" + peronObj.name);
  print("age  :" + peronObj.age.toString());

  peronObj = peronObj.copyWith(name: "raisa");
  print("new name :" + peronObj.name);

}

class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  Person copyWith({String? name, int? age}) {
    return Person(name: name ?? this.name, age: age ?? this.age);
  }
}
```
