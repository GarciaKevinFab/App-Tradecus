import 'package:flutter/material.dart';
import '../components/Layout/Layout.dart';
import '../shared/CommonSection.dart';
import '../components/Image-gallery/MasonryImagesGallery.dart'; // Asegúrate de importar correctamente el archivo

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
      bodyContent: SingleChildScrollView(
        child: Column(
          children: [
            CommonSection(
              title: 'Nuestra Galería de Viajes de Clientes',
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  MasonryImagesGallery(), // Utiliza tu widget de galería aquí
            ),
          ],
        ),
      ),
    );
  }
}
