import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyCalculator(title: ''),
    );
  }
}

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key, required this.title});
  final String title;

  @override
  State<MyCalculator> createState() => _Calculator();
}

class _Calculator extends State<MyCalculator> {
  String number1 = '';
  String operand = '';
  String number2 = '';

  void _buttonPressed(String value) {
    if (value == 'AC') {
      _resetDisplay();
      return;
    }

    if (value == '%') {
      _getPercentage();
      return;
    }

    if (value == '=') {
      _getResult();
      return;
    }

    if (value == '+/-') {
      _toggleSign();
      return;
    }
    _appendText(value);
  }

  void _resetDisplay() {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

  void _toggleSign() {
    if (number1.isNotEmpty && number1 != '0') {
      if (number1.startsWith('-')) {
        number1 = number1.substring(1);
      } else {
        number1 = '-' + number1;
      }
      setState(() {});
    }
  }

  void _getPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      _getResult();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = '${(number / 100)}';
      operand = '';
      number2 = '';
    });
  }

  void _getResult() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = '$result';

      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = '';
      number2 = '';
    });
  }

  void _appendText(String value) {
    if (value != '.' && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        _getResult();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == '.' && number1.contains('.')) return;
      if (value == '.' && (number1.isEmpty || number1 == '0')) {
        value = '0.';
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == '.' && number2.contains('.')) return;
      if (value == '.' && (number2.isEmpty || number2 == '0')) {
        value = '0.';
      }
      number2 += value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 290,
            width: 320,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '$number1$operand$number2'.isEmpty
                    ? '0'
                    : '$number1$operand$number2',
                style: const TextStyle(fontSize: 48),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(children: [
                buildButton("AC"),
                buildButton("+/-"),
                buildButton("%"),
                buildButton("÷")
              ]),
              Row(children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("×")
              ]),
              Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("-")
              ]),
              Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("+")
              ]),
              Row(children: [
                buildButton("0"),
                buildButton("."),
                buildButton("=")
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String value) {
    final screenSize = MediaQuery.of(context).size;
    Color buttonColor = Colors.orange;

    if (['AC', '+/-', '%'].contains(value)) {
      buttonColor = Colors.grey;
    }
    if (['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
        .contains(value)) {
      buttonColor = const Color.fromARGB(255, 53, 64, 70);
    }
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        height: screenSize.height / 10.5,
        width: value == '0' ? screenSize.width / 2.075 : screenSize.width / 4.3,
        child: FloatingActionButton(
          onPressed: () => _buttonPressed(value),
          shape: ['0'].contains(value)
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )
              : const CircleBorder(),
          backgroundColor: buttonColor,
          foregroundColor:
              ['AC', '+/-', '%'].contains(value) ? Colors.black : Colors.white,
          child: Text(
            value,
            textScaler: const TextScaler.linear(2),
          ),
        ),
      ),
    );
  }
}
