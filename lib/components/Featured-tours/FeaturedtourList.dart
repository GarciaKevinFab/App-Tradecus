import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FeaturedtourList extends StatelessWidget {
  final String url = dotenv.env['BASE_URL']!;
  // Asegúrate de tener definida BASE_URL

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
              color: Color(0xffF11C00),
              size: 100.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<dynamic>? featuredTours = snapshot.data;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: featuredTours!.length,
            itemBuilder: (context, index) {
              return TourCard(tour: featuredTours[index]);
            },
          );
        }
      },
    ));
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class TourCard extends StatelessWidget {
  final dynamic tour;

  TourCard({required this.tour});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(tour[
              'imageUrl']), // Asegúrate de que la estructura de tu objeto 'tour' coincida
          Text(tour['title']),
          Text(tour['description']),
        ],
      ),
    );
  }
}
