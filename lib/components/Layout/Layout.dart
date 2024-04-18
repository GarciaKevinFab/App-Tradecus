import 'package:flutter/material.dart';
import '../Footer/Footer.dart';
import '../Header/Header.dart';

class Layout extends StatelessWidget {
  final Widget bodyContent;

  // Asegúrate de que el constructor acepta un parámetro nombrado 'bodyContent'
  Layout({required this.bodyContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Header(),
      ),
      body: Center(
        child: bodyContent, // Usa el widget pasado como contenido principal.
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
