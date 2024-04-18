import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../shared/Newsletter.dart';
import '../shared/TourCard.dart';
import '../shared/SearchBar.dart' as custom;
import '../shared/CommonSection.dart';
import '../components/Layout/Layout.dart';

class ToursPage extends StatefulWidget {
  @override
  _ToursState createState() => _ToursState();
}

class _ToursState extends State<ToursPage> {
  final String BASE_URL = 'http://192.168.137.217:4000/api/v1';
  List<dynamic> tours = [];
  int currentPage = 0;
  int totalPages = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTours();
  }

  void loadTours() async {
    setState(() => isLoading = true);
    try {
      final response =
          await http.get(Uri.parse('$BASE_URL/tours?page=$currentPage'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tours = data['data'];
          totalPages = (data['count'] / 8).ceil();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load tours');
      }
    } catch (e) {
      print('Error loading tours: $e');
      setState(() {
        isLoading = false;
        // Consider setting an error message or state here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      bodyContent: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CommonSection(title: 'Todos Los Tours', height: 50),
            custom.SearchBar(),
            if (isLoading)
              Center(
                  child: SpinKitFadingCircle(
                      color: Theme.of(context).primaryColor, size: 50.0))
            else
              ListView.builder(
                itemCount: tours.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => TourCard(tour: tours[index]),
              ),
            if (totalPages > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentPage = index;
                        loadTours();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('${index + 1}'),
                    ),
                  );
                }),
              ),
            Newsletter(),
          ],
        ),
      ),
    );
  }
}
