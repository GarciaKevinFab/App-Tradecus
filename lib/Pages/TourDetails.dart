import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../components/Bookings/Booking.dart';
import '../utils/avgRating.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

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

    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    var url = Uri.parse(
        'http://192.168.137.217:4000/api/v1/review/${widget.tour['id']}');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username':
              user.username, // Utiliza el nombre de usuario del proveedor
          'reviewText': reviewController.text,
          'rating': selectedRating,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        // Si el estado no es 200, captura el cuerpo de la respuesta para obtener el mensaje de error
        Map<String, dynamic> responseBody = json.decode(response.body);
        String serverErrorMessage =
            responseBody['message'] ?? 'Unknown error occurred';
        print('Server error: $serverErrorMessage'); // Muestra en la consola
        throw Exception(
            'Error submitting review: $serverErrorMessage'); // Muestra en la UI
      }
    } catch (e) {
      print('Error: $e'); // Imprime en la consola el error completo
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
      title: Text(review['username'] ?? 'Anonymous'),
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

    String photoUrl = widget.tour['photos']?.first['secureUrl'] ??
        'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tour['title'] ?? 'Tour Details',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(color: Colors.red, height: 4.0),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.0,
                      viewportFraction:
                          1.0, // Ocupa todo el ancho de la pantalla // Puedes ajustar el aspecto según tus necesidades
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      autoPlay: false,
                    ),
                    items: (widget.tour['photos'] as List<dynamic>)
                        .map<Widget>((photo) {
                      return Image.network(
                        photo['secureUrl'] ?? 'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tour['title'] ?? 'Unavailable',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: avgRating,
                          itemBuilder: (context, index) =>
                              Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(height: 8),
                        Text('$totalRating reseñas',
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .account_balance_wallet, // Changed to a wallet icon that can symbolize a bill
                              color: Colors.red,
                            ),
                            SizedBox(
                                width: 8), // Correct placement inside the list
                            Text(
                              'S/.${widget.tour['price']?.toString() ?? '0'}', // Currency symbol changed to S/.
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                                width: 8), // Correct placement inside the list
                            Icon(
                              Icons.person,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${widget.tour['duration']?.toString() ?? '...'} Horas',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${widget.tour['maxGroupSize']?.toString() ?? 'Unknown'}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text('Descripción:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(widget.tour['desc'] ?? 'No disponible',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 20),
                        if (errorMessage != null)
                          Text(errorMessage!,
                              style: TextStyle(color: Colors.red)),
                        Text('Escribe una reseña:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        RatingBar.builder(
                          initialRating: selectedRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            setState(() {
                              selectedRating = rating;
                            });
                          },
                        ),
                        TextField(
                          controller: reviewController,
                          decoration:
                              InputDecoration(hintText: 'Danos tu opinion'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: submitReview,
                          child: Text(
                            'Enviar',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Reseñas',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        ...widget.tour['reviews']
                            .map((review) => reviewListTile(review))
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToBooking,
        child: Icon(Icons.event_available,
            color: Colors.white), // Icon to indicate booking availability
        backgroundColor: Colors.red,
      ),
    );
  }
}
