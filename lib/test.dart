void main() {
  void Function(String)? onDone; // define function
  onDone?.call("1stime");

  // write functiond defination
  onDone = (msg) => print('work has been finished ${msg}');

  onDone?.call("2nd time");

  var button = new MyButton();
}

class MyButton {
  final void Function()? onTap;
  MyButton({this.onTap});

  void onPress() {
    onTap?.call();
  }
}
