import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> testimonials = [
      "Maravillosa atención. Las ofertas que ofrecen son súper buenas, un gran profesional que se adapta a las necesidades de su cliente. En resumen 100% recomendable. Gracias!",
      "Un servicio de primera y súper puntual. Solicité una partida de nacimiento que requería para una gestión en el Consulado y me la prometieron para dentro de tres semanas y justo en tres semanas exactas tuve la partida. Altamente satisfecho.",
      "Tuvimos muy buena experiencia con TRADECUS SRL!!! Hemos hecho un viaje inolvidable a Cusco y ya con ganas de repetirlo!. Gracias por la atención, sin duda la recomiendo TRADECUS SRL.",
      "Excelente trato, muy seguro mi viaje a Cusco con ellos. Recomendados 100%"
    ];

    return CarouselSlider.builder(
      itemCount: testimonials.length,
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        enlargeCenterPage: true,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                testimonials[index],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Cliente",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
