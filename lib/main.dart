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
      debugShowCheckedModeBanner: false,
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
  final String _displayText = 'Hello, Widget Concepts!';
  bool _isBoxVisible = true;
  double _containerWidth = 100.0;
  Color _boxColor = Colors.red;

  void _toggleVisibility() {
    setState(() {
      _isBoxVisible = !_isBoxVisible;
    });
  }

  void _toggleContainerSize() {
    setState(() {
      _containerWidth = _containerWidth == 100.0 ? 200.0 : 100.0;
    });
  }

  void _toggleBoxColor() {
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
            if (_isBoxVisible)
              AnimatedContainer(
                width: _containerWidth,
                height: 100.0,
                color: _boxColor,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: const Center(
                  child: Text('Container'),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _displayText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleVisibility,
              child: Text(_isBoxVisible ? 'Hide Box' : 'Show Box'),
            ),
            ElevatedButton(
              onPressed: _toggleContainerSize,
              child: const Text('Toggle Container Size'),
            ),
            ElevatedButton(
              onPressed: _toggleBoxColor,
              child: const Text('Toggle Box Color'),
            ),
          ],
        ),
      ),
    );
  }
}
