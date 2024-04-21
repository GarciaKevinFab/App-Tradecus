import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize =>
      Size.fromHeight(100); // Ajustamos esto según sea necesario.
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing:
          0, // Elimina cualquier espaciado adicional alrededor del título.
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para el AppBar.
          border: Border(
            bottom: BorderSide(
                color: Colors.red,
                width: 1), // Borde rojo delgado en la parte inferior.
          ),
        ),
      ),
      title: Container(
        // Ajustamos el contenedor del logo para alinear el logo verticalmente.
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            bottom:
                12.0), // Espacio adicional para compensar el borde inferior.
        child: Image.asset(
          'assets/images/logo.png',
          height: 50, // Altura específica del logo.
        ),
      ),
      elevation: 0, // Elimina la sombra debajo del AppBar.
      backgroundColor: Colors
          .transparent, // Fondo transparente para mostrar el BoxDecoration.
    );
  }
}
