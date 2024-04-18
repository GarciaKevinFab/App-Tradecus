import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String subtitle;

  const Subtitle({Key? key, required this.subtitle, required Color color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(
        // Aquí configuras el estilo del subtítulo, como el tamaño de fuente, color, etc.
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}
