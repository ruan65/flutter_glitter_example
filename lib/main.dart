import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _pieceSize = 8.0;
const _numPieces = 100;
const _duration = Duration(milliseconds: 1000);
const x = 255;
final rnd = Random();
Color getRandomColor() => Color.fromARGB(
    rnd.nextInt(x), rnd.nextInt(x), rnd.nextInt(x), rnd.nextInt(x));

//Color getRandomOpaqueColor() =>
//    Color.fromARGB(x - 1, rnd.nextInt(x), rnd.nextInt(x), rnd.nextInt(x));

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _width, _height;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: _duration,
    );
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

  Widget _createAnimatedGlitterPiece(BuildContext context,
      {bool reversed = false, bool animated = true}) {
    final colorTween = ColorTween(
        begin: reversed ? Colors.transparent : getRandomColor(),
        end: reversed ? getRandomColor() : Colors.transparent);
    Animation animation = colorTween.animate(_controller);
    final piece = animated
        ? AnimatedBuilder(
            animation: animation,
            builder: (BuildContext ctx, Widget w) => Container(
                width: _pieceSize, height: _pieceSize, color: animation.value))
        : Container(
            width: _pieceSize, height: _pieceSize, color: getRandomColor());

    final leftOffset = rnd.nextDouble() * (_width - _pieceSize);
    final topOffset = rnd.nextDouble() * (_height - _pieceSize);
    return Positioned(
      top: topOffset,
      left: leftOffset,
      child: piece,
    );
  }

  List<Widget> _createGlitterPieces(BuildContext context, int numPieces) {
    final result = <Widget>[];
    for (var i = 0; i < numPieces; i++) {
      result.add(_createAnimatedGlitterPiece(context, animated: false));
      result.add(_createAnimatedGlitterPiece(context));
      result.add(_createAnimatedGlitterPiece(context, reversed: true));
    }
    return result;
  }

  _onTap() {
    setState(() {
    });
  }
  _onLongPress() {

  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: GestureDetector(
          onTap: _onTap,
          onLongPress: _onLongPress,
          child: Container(
              color: Colors.black,
              child: Stack(
                  children: _createGlitterPieces(context, _numPieces))),
        ));
  }
}
