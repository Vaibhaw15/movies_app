import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImboxoLogo extends StatelessWidget {
  final double width;
  final double height;
  final bool small;
  ImboxoLogo({this.width = 28, this.height = 44, this.small = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _BorderedLetter('I', height, width,small),
          SizedBox(width: 4),
          _BorderedLetter('M', height, width,small),
          SizedBox(width: 4),
          _BorderedLetter('B', height, width,small),
          SizedBox(width: 4),
          _BorderedLetter('O', height, width,small),
          SizedBox(width: 4),
          _BorderedLetter('X', height, width,small),
          SizedBox(width: 4),
          _BorderedLetter('O', height, width,small),
        ],
      ),
    );
  }
}

// Individual bordered letter widget
class _BorderedLetter extends StatelessWidget {
  final String letter;
  final double height;
  final double width;
  final bool small;

  const _BorderedLetter(this.letter,this.height, this.width,this.small);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white,
            fontSize: small ?14:28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}