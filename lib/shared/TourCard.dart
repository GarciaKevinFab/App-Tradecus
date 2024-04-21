import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/avgRating.dart'; // Make sure this path is correct
import '../Pages/TourDetails.dart'; // Make sure this path is correct

class TourCard extends StatefulWidget {
  final dynamic tour;

  const TourCard({Key? key, required this.tour}) : super(key: key);

  @override
  _TourCardState createState() => _TourCardState();
}

class _TourCardState extends State<TourCard> {
  late final String photos;
  bool isTimedOut = false;

  @override
  void initState() {
    super.initState();
    photos = widget.tour['photos'] is List && widget.tour['photos'].isNotEmpty
        ? widget.tour['photos'][0]['secureUrl']
        : 'https://example.com/uploads/default-image.png';

    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        setState(() => isTimedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tour == null) {
      return CircularProgressIndicator();
    }

    final String title = widget.tour['title'] ?? 'Título no disponible';
    final String city = widget.tour['city'] ?? 'Ciudad no disponible';
    final String price = widget.tour['price']?.toString() ?? '0';
    final bool featured = widget.tour['featured'] ?? false;
    final List<dynamic> reviews = widget.tour['reviews'] ?? [];

    var ratings = calculateAvgRating(reviews);
    double avgRating = ratings['avgRating']?.toDouble() ?? 0.0;
    int totalRating = ratings['totalRating']?.toInt() ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailsPage(tour: widget.tour),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: photos,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.red)),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                if (featured)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Destacado',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            ListTile(
              title: Text(title),
              leading: Icon(Icons.location_on),
              trailing: RatingBarIndicator(
                rating: avgRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              subtitle: Text('$city - $avgRating ($totalRating valoraciones)'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('S/.$price /por persona',
                      style: TextStyle(fontSize: 16)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TourDetailsPage(tour: widget.tour),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('Reservar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
