import 'package:flutter/material.dart';
import '../components/Layout/Layout.dart';
import '../shared/Subtitle.dart';

class AboutPage extends StatelessWidget {
  final Color primaryColor =
      const Color.fromARGB(255, 228, 89, 24); // Color principal

  @override
  Widget build(BuildContext context) {
    return Layout(
      bodyContent: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCard(
                context,
                title:
                    Subtitle(subtitle: 'Sobre Nosotros', color: primaryColor),
                content:
                    'Convertirnos en el operador turístico líder en la región que brinda servicios de viajes excelentes e innovadores a nuestros clientes.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title: Subtitle(subtitle: 'Visión', color: primaryColor),
                content:
                    'Convertirnos en el operador turístico líder en la región que brinda servicios de viajes excelentes e innovadores a nuestros clientes.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title: Subtitle(subtitle: 'Misión', color: primaryColor),
                content:
                    'Brindar una experiencia de viaje única para todos de una manera sostenible, honesta y transparente.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title: Subtitle(subtitle: 'Valores', color: primaryColor),
                content:
                    'Transparencia, integridad, pasión por los viajes, enfoque al cliente, y compromiso con el turismo sostenible.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title: Subtitle(
                    subtitle: 'Pasión por los Viajes:', color: primaryColor),
                content:
                    'No somos solo un negocio, sino un grupo de entusiastas de los viajes que sienten pasión por explorar y compartir la belleza y la rica historia de Cusco con el mundo.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title: Subtitle(
                    subtitle: 'Enfoque al Cliente', color: primaryColor),
                content:
                    'Nuestros clientes están en el corazón de todo lo que hacemos. Nos esforzamos por proporcionar servicios excepcionales que satisfacen y superan las expectativas de nuestros clientes, asegurando que tengan una experiencia inolvidable cuando elijan viajar con nosotros.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title: Subtitle(
                    subtitle: 'Turismo Sostenible', color: primaryColor),
                content:
                    'Como custodios del rico patrimonio de Cusco, creemos en la promoción de prácticas de turismo sostenible que protejan y preserven nuestro medio ambiente y las comunidades locales para que las generaciones futuras puedan disfrutarlas.',
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title:
                    Subtitle(subtitle: 'Nuestro Equipo', color: primaryColor),
                content:
                    'Un equipo dedicado de profesionales apasionados por proporcionar experiencias inolvidables.',
              ),
              const SizedBox(height: 16.0),
              Image.asset('assets/images/teamImg.webp'),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                title:
                    Subtitle(subtitle: 'Nuestra Historia', color: primaryColor),
                content:
                    'TRADECUS SRL nació el 26 de junio de 2015, fruto de un sueño de acercar las maravillas de Cusco a viajeros de todo el mundo...',
              ),
              const SizedBox(height: 16.0),
              Image.asset('assets/images/logo.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required Widget title, required String content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
