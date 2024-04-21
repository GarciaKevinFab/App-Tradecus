import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const BASE_URL = "http://192.168.137.217:4000/api/v1";

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController maxGroupSizeController = TextEditingController();
  bool _isLoading = false;

  void searchHandler() async {
    final String location = locationController.text.trim();
    final String duration = durationController.text.trim();
    final String maxGroupSize = maxGroupSizeController.text.trim();

    if (location.isEmpty || duration.isEmpty || maxGroupSize.isEmpty) {
      Fluttertoast.showToast(
        msg: '¡Todos los campos son obligatorios!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    final url = Uri.parse(
        '$BASE_URL/tours/search/getTourBySearch?city=$location&duration=$duration&maxGroupSize=$maxGroupSize');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: 'No se encontraron resultados',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }

      final result = json.decode(response.body);

      Navigator.pushNamed(
        context,
        '/search-results',
        arguments: result['data'],
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al conectar con el servidor',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10), // Reducir el margen superior a 10px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              Colors.grey.withOpacity(0.7), // Hacer el borde un poco más oscuro
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: durationController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.access_time),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            child: TextField(
              controller: maxGroupSizeController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.group),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            icon: _isLoading ? CircularProgressIndicator() : Icon(Icons.search),
            onPressed: _isLoading ? null : searchHandler,
          ),
        ],
      ),
    );
  }
}
