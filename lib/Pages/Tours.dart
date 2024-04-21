import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../shared/Newsletter.dart';
import '../shared/TourCard.dart';
import '../shared/SearchBar.dart' as custom;

class ToursPage extends StatefulWidget {
  @override
  _ToursState createState() => _ToursState();
}

class _ToursState extends State<ToursPage> {
  static const String baseUrl = 'http://192.168.137.217:4000/api/v1';
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
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/tours?page=$currentPage'));
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
      debugPrint('Error loading tours: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildLoadingIndicator() {
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.red, // Cambia el color a rojo aquí
        size: 50.0,
      ),
    );
  }

  Widget buildPageIndicator() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: List.generate(totalPages, (index) {
          return ChoiceChip(
            label: Text('${index + 1}'),
            selected: currentPage == index,
            selectedColor:
                Colors.red, // Color de fondo del elemento seleccionado
            labelStyle: TextStyle(color: Colors.white), // Color del texto
            backgroundColor: Colors.red
                .withOpacity(0.5), // Color de fondo cuando no está seleccionado
            onSelected: (bool selected) {
              // ... el resto del código no cambia ...
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Todos Los Tours',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.red, // Color rojo para el borde
            height: 4.0,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 15.0), // Agregar margen hacia abajo de 15px
              child: custom.SearchBar(),
            ),
          ),
          isLoading
              ? SliverFillRemaining(
                  child: buildLoadingIndicator(),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TourCard(tour: tours[index]),
                    childCount: tours.length,
                  ),
                ),
          SliverToBoxAdapter(
            child: buildPageIndicator(),
          ),
          SliverToBoxAdapter(
            child: Newsletter(),
          ),
        ],
      ),
    );
  }
}
