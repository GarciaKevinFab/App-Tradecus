import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../components/Bookings/Booking.dart';
import '../utils/avgRating.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TourDetailsPage extends StatefulWidget {
  final Map tour;

  TourDetailsPage({Key? key, required this.tour}) : super(key: key);

  @override
  _TourDetailsPageState createState() => _TourDetailsPageState();
}

class _TourDetailsPageState extends State<TourDetailsPage> {
  double selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    var url = Uri.parse(
        'http://192.168.137.217:4000/api/v1/review/${widget.tour['id']}');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username':
              'USERNAME', // Idealmente, obtén este valor desde un estado o contexto de la aplicación
          'reviewText': reviewController.text,
          'rating': selectedRating,
        }),
      );

      if (response.statusCode == 200) {
        // Suponiendo que necesitas recargar o actualizar la información del tour después de enviar una reseña
        Navigator.pop(context, true);
      } else {
        throw Exception('Error al enviar la reseña.');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget reviewListTile(Map review) {
    return ListTile(
      title: Text(review['username'] ?? 'Anónimo'),
      subtitle: Text(review['reviewText'] ?? ''),
      trailing: RatingBarIndicator(
        rating: review['rating']?.toDouble() ?? 0.0,
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
        itemCount: 5,
        itemSize: 20.0,
        direction: Axis.horizontal,
      ),
    );
  }

  void navigateToBooking() {
    final avgRatingResult = calculateAvgRating(widget.tour['reviews'] ?? []);
    double avgRating = avgRatingResult['avgRating']?.toDouble() ?? 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          formKey: GlobalKey<FormState>(),
          tour: widget.tour,
          avgRating: avgRating,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratings = calculateAvgRating(widget.tour['reviews'] ?? []);
    double avgRating = ratings['avgRating']?.toDouble() ?? 0.0;
    int totalRating = ratings['totalRating']?.toInt() ?? 0;
    List<dynamic> reviews = widget.tour['reviews'] ?? [];

    String photoUrl = widget.tour['photos']?.first['secureUrl'] ??
        'https://example.com/default-image.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tour['title'] ?? 'Detalles del Tour'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photoUrl, height: 300, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.tour['title'] ?? 'Título no disponible',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(
                      '${widget.tour['city'] ?? 'Ciudad no disponible'} - $avgRating ($totalRating valoraciones)'),
                  Text(
                      'S/.${widget.tour['price']?.toString() ?? '0'} /por persona'),
                  Text(
                      'Duración: ${widget.tour['duration']?.toString() ?? 'Desconocida'} Horas'),
                  Text(
                      'Grupo máximo: ${widget.tour['maxGroupSize']?.toString() ?? 'Desconocido'} personas'),
                  Text(
                      'Descripción: ${widget.tour['desc'] ?? 'No disponible'}'),
                  SizedBox(height: 20),
                  if (errorMessage != null)
                    Text(errorMessage!, style: TextStyle(color: Colors.red)),
                  Text('Deja tu reseña:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  RatingBar.builder(
                    initialRating: selectedRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) =>
                        setState(() => selectedRating = rating),
                  ),
                  TextField(
                    controller: reviewController,
                    decoration:
                        InputDecoration(hintText: 'Escribe tu reseña aquí'),
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: submitReview,
                          child: Text('Enviar reseña'),
                        ),
                  Text('Reseñas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...reviews.map((review) => reviewListTile(review)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToBooking,
        label: Text('Reservar'),
        icon: Icon(Icons.book_online),
      ),
    );
  }
}
