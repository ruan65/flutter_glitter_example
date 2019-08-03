import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _pieceSize = 8.0;
const _numPieces = 100;
const _duration = Duration(milliseconds: 1000);
final _colorTween = ColorTween(begin: Colors.green, end: Colors.transparent);
final _random = Random();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _width, _height;

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: _duration,
    );
    _animation = _colorTween.animate(_controller);
    _controller.forward();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _createAnimatedGlitterPiece(BuildContext context) {
    final piece = AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext ctx, Widget w) => Container(
            width: _pieceSize, height: _pieceSize, color: _animation.value));

    final leftOffset = _random.nextDouble() * (_width - _pieceSize);
    final topOffset = _random.nextDouble() * (_height - _pieceSize);
    return Positioned(
      top: topOffset,
      left: leftOffset,
      child: piece,
    );
  }

  Widget _createStaticGlitterPiece() {
    final piece =
        Container(width: _pieceSize, height: _pieceSize, color: Colors.blue);
    final leftOffset = _random.nextDouble() * (_width - _pieceSize);
    final topOffset = _random.nextDouble() * (_height - _pieceSize);
    return Positioned(
      top: topOffset,
      left: leftOffset,
      child: piece,
    );
  }

  List<Widget> _createGlitterPieces(BuildContext context, int numPieces) {
    final result = <Widget>[];
    for (var i = 0; i < numPieces; i++) {
      result.add(_createStaticGlitterPiece());
      result.add(_createAnimatedGlitterPiece(context));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
            child: Container(
                color: Colors.pink[100],
                child: Stack(
                    children: _createGlitterPieces(context, _numPieces)))));
  }
}
