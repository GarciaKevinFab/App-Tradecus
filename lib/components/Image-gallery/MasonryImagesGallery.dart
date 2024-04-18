import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const List<String> galleryImages = [
  'assets/images/gallery-01.webp',
  'assets/images/gallery-07.webp',
  'assets/images/gallery-02.webp',
  'assets/images/gallery-06.webp',
  'assets/images/gallery-03.webp',
  'assets/images/gallery-04.webp',
  'assets/images/gallery-05.webp',
  'assets/images/gallery-08.webp',
];

class MasonryImagesGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.4, // Ajusta la altura según lo que necesites
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4, // Número de columnas para el grid
        itemCount: galleryImages.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Acción al tocar la imagen
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content:
                        Image.asset(galleryImages[index], fit: BoxFit.cover),
                  );
                },
              );
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage(galleryImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.count(
            2, index.isEven ? 2 : 3), // Tamaños dinámicos
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
