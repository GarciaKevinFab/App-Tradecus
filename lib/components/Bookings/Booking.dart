import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../DNI/Dni.dart'; // Asegúrate de que este import se refiera al lugar correcto de tu archivo DniField
import '../Payment/Payment.dart'; // Asegúrate de que este import se refiera al lugar correcto de tu archivo Payment

class BookingScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final dynamic tour;
  final double avgRating;

  BookingScreen({
    Key? key,
    required this.formKey,
    required this.tour,
    required this.avgRating,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int guestSize = 1;
  String tourType = 'group';
  String phone = '';
  DateTime? bookAt;
  List<String> dni = [''];
  List<Map<String, dynamic>> userData = [{}];

  double totalAmount = 0;
  bool isDataLoading = false;
  int maxGuests = 0;
  int currentGuests = 0;

  @override
  void initState() {
    super.initState();
    fetchTourDetails();
  }

  Future<void> fetchTourDetails() async {
    try {
      setState(() => isDataLoading = true);
      var tourUrl = Uri.parse(
          'http://192.168.137.217:4000/api/v1/tours/${widget.tour["_id"]}');
      var bookingUrl = Uri.parse(
          'http://192.168.137.217:4000/api/v1/booking/count/${widget.tour["_id"]}');

      var tourResponse = await http.get(tourUrl);
      var bookingResponse = await http.get(bookingUrl);

      if (tourResponse.statusCode == 200 && bookingResponse.statusCode == 200) {
        var tourData = json.decode(tourResponse.body);
        var bookingData = json.decode(bookingResponse.body);

        maxGuests = tourData['maxGroupSize'] ?? 0;
        currentGuests = bookingData ?? 0;

        setState(() {
          totalAmount = calculateTotal();
          isDataLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching data: $e'),
      ));
      setState(() {
        isDataLoading = false;
      });
    }
  }

  double calculateTotal() {
    int multiplier = tourType == 'private' ? 4 : 1;
    return (widget.tour['price']?.toDouble() ?? 0.0) * multiplier * guestSize;
  }

  void updateLists(int newGuestSize) {
    setState(() {
      guestSize = newGuestSize;
      totalAmount = calculateTotal();

      dni = List<String>.generate(newGuestSize, (_) => '');
      userData = List<Map<String, dynamic>>.generate(
        newGuestSize,
        (_) => <String, dynamic>{},
      );
    });
  }

  void onReserve() {
    if (bookAt == null || bookAt!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid future date.'),
      ));
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid phone number.'),
      ));
      return;
    }

    for (var d in dni) {
      if (d.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter all required DNI information.'),
        ));
        return;
      }
    }

    for (var userDatum in userData) {
      if (userDatum.isEmpty || userDatum.values.any((v) => v.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please complete all required fields.'),
        ));
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(
          tour: widget.tour,
          quantity: guestSize,
          totalPrice: totalAmount,
          booking: {'guestSize': guestSize, 'bookAt': bookAt, 'phone': phone},
          user: {},
          dni: dni,
          userData: userData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDataLoading) {
      return Center(child: CircularProgressIndicator());
    }

    double price = widget.tour['price']?.toDouble() ?? 0.0;
    int reviewCount = widget.tour['reviews']?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Reserva para ${widget.tour['title']}"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "S/.$price /por persona",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            RatingBarIndicator(
              rating: widget.avgRating,
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 20.0,
            ),
            Text("($reviewCount reviews)"),
            DropdownButton<String>(
              value: tourType,
              onChanged: (newValue) {
                setState(() {
                  tourType = newValue!;
                  totalAmount = calculateTotal();
                });
              },
              items: <String>['group', 'private']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Número de personas'),
              keyboardType: TextInputType.number,
              initialValue: guestSize.toString(),
              onChanged: (newValue) {
                int newGuestSize = int.tryParse(newValue) ?? guestSize;
                if (newGuestSize > 0 &&
                    newGuestSize <= maxGuests - currentGuests) {
                  updateLists(newGuestSize);
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
              onChanged: (newValue) {
                phone = newValue;
              },
            ),
            ...List.generate(
              guestSize,
              (index) => DniField(
                index: index,
                dni: dni,
                setDni: (List<String?> newDniList) {
                  setState(() {
                    dni = newDniList.cast<String>();
                  });
                },
                userData: userData[index], // Pass the Map directly
                setUserData: (Map<String, dynamic> newUserData) {
                  setState(() {
                    userData[index] = newUserData;
                  });
                },
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Fecha de reserva'),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: bookAt ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() => bookAt = pickedDate);
                }
              },
            ),
            Text("Total: S/.$totalAmount"),
            ElevatedButton(
              onPressed: onReserve,
              child: Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}
