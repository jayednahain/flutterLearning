typedef PriceFormatter = String Function(double amount);

void main(List<String> args) {
  print("hellow");

  // creating function which a function as a param
  void runFormatter(PriceFormatter priceFormatter) =>
      print(priceFormatter(12.5));

  // pass direct Anonymous Function
  // runFormatter((a) => '\$${a.toStringAsFixed(2)}');

  String formatDollar(double a) {
    return '\$${a.toStringAsFixed(2)}';
  }

  // runFormatter(formatDollar);
  // final rect = Rectangle(
  //   width: 10,
  //   height: 5,
  // );

  var user = User(name: "yaed", age: 45);
}

class Client {
  final String _baseUrl;

  // ১. প্যারামিটার নিল (url)
  Client(String url)
    // ২. বডিতে ঢোকার আগেই ':'-এর ভেতরে হিসাব করে final ভেরিয়েবলে মান বসিয়ে দিল
    : _baseUrl = '$url/'
  // ৩. এবার বডিতে ঢুকল (এখন _baseUrl পুরোপুরি রেডি এবং লক হয়ে গেছে)
  {
    print(_baseUrl);
  }
}

class User {
  final String name;
  final int age;

  // কোনো হিসাব-নিকাশ নেই, তাই সরাসরি this. ব্যবহার করা হয়েছে
  User({required this.name, required this.age}) {
    print('User $name created');
  }
}

class Rectangle {
  final double width;
  final double height;
  final double area; // এটি ইউজার দেবে না, ক্লাস নিজে হিসাব করবে

  // বডি {} চালু হওয়ার আগেই ':' দিয়ে area হিসাব করে সেট করা হচ্ছে
  Rectangle({required this.width, required this.height})
    : area = width * height {
    print('Rectangle created with area: $area');
  }
}
