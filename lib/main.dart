import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Concepts Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showText = true;
  double _containerWidth = 100.0;
  Color _boxColor = Colors.red;

  void _toggleText() {
    setState(() {
      _showText = !_showText;
    });
  }

  void _changeContainerSize() {
    setState(() {
      _containerWidth = _containerWidth == 100.0 ? 200.0 : 100.0;
    });
  }

  void _changeBoxColor() {
    setState(() {
      _boxColor = _boxColor == Colors.red ? Colors.blue : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Concepts Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showText) ...[
              const Text(
                'Hello, Widget Concepts!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
            ],
            Container(
              width: _containerWidth,
              height: 100.0,
              color: _boxColor,
              child: const Center(
                child: Text('Container'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleText,
              child: const Text('Toggle Text'),
            ),
            ElevatedButton(
              onPressed: _changeContainerSize,
              child: const Text('Change Container Size'),
            ),
            ElevatedButton(
              onPressed: _changeBoxColor,
              child: const Text('Change Box Color'),
            ),
          ],
        ),
      ),
    );
  }
}
