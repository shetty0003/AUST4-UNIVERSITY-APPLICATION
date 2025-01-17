import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ColorClashGameScreen extends StatefulWidget {
  const ColorClashGameScreen({super.key});

  @override
  _ColorClashGameScreenState createState() => _ColorClashGameScreenState();
}

class _ColorClashGameScreenState extends State<ColorClashGameScreen> {
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  final List<String> _colorNames = ['Red', 'Blue', 'Green', 'Yellow'];
  late Color _currentTargetColor;
  late String _currentRule;
  late Timer _timer;
  int _score = 0;
  int _timeLeft = 30;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startGame() {
    _score = 0;
    _timeLeft = 30;
    _isGameOver = false;
    _generateNewRule();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _isGameOver = true;
          _timer.cancel();
        }
      });
    });
  }

  void _generateNewRule() {
    final random = Random();
    final index = random.nextInt(_colors.length);
    setState(() {
      _currentTargetColor = _colors[index];
      _currentRule = 'Tap ${_colorNames[index]}';
    });
  }

  void _handleColorTap(Color color) {
    if (_isGameOver) return;

    if (color == _currentTargetColor) {
      setState(() {
        _score++;
      });
      _generateNewRule();
    } else {
      setState(() {
        if (_score > 0) _score--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Clash'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: _isGameOver
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: $_score',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: _startGame,
              child: const Text('Play Again', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $_score', style: const TextStyle(fontSize: 20)),
                Text('Time: $_timeLeft', style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentRule,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _colors.map((color) {
                    return GestureDetector(
                      onTap: () => _handleColorTap(color),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
