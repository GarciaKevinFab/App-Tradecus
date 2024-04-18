import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();

  // Ajustamos la altura preferida para acomodar el logo.
  @override
  Size get preferredSize =>
      Size.fromHeight(50); // Asumiendo que el logo tiene una altura de 80px.
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor:
          Color.fromARGB(255, 228, 89, 24), // Color de fondo del AppBar
      // Usamos un container para controlar mejor el tamaño del logo.
      title: Container(
        height: widget.preferredSize
            .height, // Utilizamos la altura preferida para el container del logo.
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit
              .contain, // Hace que la imagen del logo mantenga sus proporciones.
        ),
      ),
      // Eliminamos todos los botones y acciones adicionales para un diseño limpio.
    );
  }
}
