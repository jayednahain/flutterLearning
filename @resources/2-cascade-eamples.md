# example 1

## ..add() মানে “একই লিস্টে আবার add করো”।

```dart
void main() {
  List<String> fruits = [];
  fruits.add("mango");
  fruits.add("orage");
  fruits.add("banana");

   print(fruits);
  List<String> names = []
    ..add("himan")
    ..add('raisa')
    ..add("jafnun");
   print(names);

}
```

# example -2

```dart

class Person {
  String names = "";
  int age = 10;

  void sayHi() {
    print('hellow my name is ${names} im ${age} years old');
  }
}

void main() {
  var p = Person()
    ..names = "jayed"
    ..age = 10
    ..sayHi();
}
```

- .. ছাড়া লিখলে এরকম হতো:

```dart
var p = Person();
p.name = 'জায়েদ';
p.age = 25;
p.sayHi();
```
