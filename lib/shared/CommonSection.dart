import 'package:flutter/material.dart';

class CommonSection extends StatelessWidget {
  final String title;
  final Widget? child; // Opcional: para añadir más contenido al widget
  final double height; // Altura específica para la sección
  final Color backgroundColor; // Color de fondo configurable

  const CommonSection({
    Key? key,
    required this.title,
    required this.height,
    this.child,
    this.backgroundColor = Colors.white, // Valor por defecto de blanco
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(vertical: 24.0),
      color: backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left,
            ),
            if (child != null) ...[
              SizedBox(
                  height:
                      16.0), // Añade un espacio entre el título y el contenido adicional
              child! // Si se proporciona un hijo, se muestra aquí
            ],
          ],
        ),
      ),
    );
  }
}
