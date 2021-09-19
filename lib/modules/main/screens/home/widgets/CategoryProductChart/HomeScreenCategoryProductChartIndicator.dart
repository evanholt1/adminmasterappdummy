import 'package:flutter/material.dart';

class HomeScreenCategoryProductCountIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const HomeScreenCategoryProductCountIndicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 10,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: isSquare ? BoxShape.rectangle : BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Expanded(child: Text(text, style: TextStyle(fontSize: 9, color: textColor, fontWeight: FontWeight.bold)))
      ],
    );
  }
}
