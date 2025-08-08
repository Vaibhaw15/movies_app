import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImboxoLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _BorderedLetter('I'),
          SizedBox(width: 4),
          _BorderedLetter('M'),
          SizedBox(width: 4),
          _BorderedLetter('B'),
          SizedBox(width: 4),
          _BorderedLetter('O'),
          SizedBox(width: 4),
          _BorderedLetter('X'),
          SizedBox(width: 4),
          _BorderedLetter('O'),
        ],
      ),
    );
  }
}

// Individual bordered letter widget
class _BorderedLetter extends StatelessWidget {
  final String letter;

  const _BorderedLetter(this.letter);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 44,
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
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}