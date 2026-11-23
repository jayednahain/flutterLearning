```dart




class SimCard {
  final String operatorName;
  SimCard(this.operatorName);

  void connect(){
    print('${operatorName} HAS connected');
  }
}

class Phone {
  final SimCard sim;
  Phone(this.sim);

  void call(){
    print("phone calling");
    sim.connect();
  }

}


void main() {
  final gpOperator = SimCard("GrameenPhone");
  final myPhone = Phone(gpOperator);
  myPhone.call();
}

```