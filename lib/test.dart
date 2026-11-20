typedef PriceFormatter = String Function(double amount);

void main(List<String> args) {
  print("hellow");

  void runFormatter(PriceFormatter priceFormatter) =>
      print(priceFormatter(12.5));
}
