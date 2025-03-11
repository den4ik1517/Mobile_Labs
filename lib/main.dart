import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  CounterScreenState createState() => CounterScreenState();
}

class CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();
  Color _bgColor = Colors.white;

  void _processInput() {
    final String input = _controller.text.trim();
    setState(() {
      if (input == 'Avada Kedavra') {
        _counter = 0;
        _bgColor = Colors.redAccent;
      } else {
        final int? number = int.tryParse(input);
        if (number != null) {
          _counter += number;
          _bgColor = Colors.greenAccent;
        } else {
          _bgColor = Colors.yellowAccent;
        }
      }
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магічний Лічильник')),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _bgColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Лічильник: $_counter',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Введіть число або закляття',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _processInput,
                child: const Text('Застосувати'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
