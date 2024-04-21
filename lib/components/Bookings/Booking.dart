import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../DNI/Dni.dart';
import '../Payment/Payment.dart';

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

  double totalAmount = 0.0;
  bool isDataLoading = false;
  int maxGuests = 0;
  int currentGuests = 0;

  TextEditingController dateController = TextEditingController();
  TextEditingController guestSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    guestSizeController.text = guestSize
        .toString(); // Inicializa el controlador con el tamaño actual de invitados
    guestSizeController
        .addListener(_updateGuestSize); // Añade un listener para el controlador
    fetchTourDetails();
  }

  @override
  void dispose() {
    dateController.dispose();
    guestSizeController.dispose(); // Desechar el controlador
    super.dispose();
  }

  void _updateGuestSize() {
    int newGuestSize = int.tryParse(guestSizeController.text) ?? 1;
    if (newGuestSize > maxGuests) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'El número máximo de personas para este tour es $maxGuests.'),
          duration: Duration(seconds: 2),
        ),
      );
      guestSizeController.text =
          guestSize.toString(); // Restablecer al valor anterior correcto
    } else if (newGuestSize <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El número de personas debe ser al menos 1.'),
          duration: Duration(seconds: 2),
        ),
      );
      guestSizeController.text = guestSize.toString();
    } else {
      updateLists(newGuestSize);
    }
  }

  Future<void> fetchTourDetails() async {
    setState(() => isDataLoading = true);
    var tourUrl = Uri.parse(
        'http://192.168.137.217:4000/api/v1/tours/${widget.tour["_id"]}');
    var bookingUrl = Uri.parse(
        'http://192.168.137.217:4000/api/v1/booking/count/${widget.tour["_id"]}');

    try {
      var tourResponse = await http.get(tourUrl);
      var bookingResponse = await http.get(bookingUrl);

      if (tourResponse.statusCode == 200 && bookingResponse.statusCode == 200) {
        var tourData = json.decode(tourResponse.body)['data'];
        print(tourData);
        var bookingData = json.decode(bookingResponse.body);

        maxGuests = tourData['maxGroupSize'] ?? 0;

        currentGuests =
            bookingData is int ? bookingData : (bookingData['count'] ?? 0);

        totalAmount = calculateTotal();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    } finally {
      setState(() => isDataLoading = false);
    }
  }

  double calculateTotal() {
    int multiplier = tourType == 'private' ? 4 : 1;
    return (widget.tour['price']?.toDouble() ?? 0.0) * multiplier * guestSize;
  }

  void updateGuestSize(String newValue) {
    int newGuestSize = int.tryParse(newValue) ?? guestSize;
    if (newGuestSize > 0 && newGuestSize <= maxGuests - currentGuests) {
      setState(() {
        guestSize = newGuestSize;
        totalAmount = calculateTotal();
        dni = List<String>.generate(newGuestSize, (_) => '');
        userData = List<Map<String, dynamic>>.generate(newGuestSize, (_) => {});
      });
    }
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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red), // Indicador de progreso en rojo
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Reserva para ${widget.tour['title']}"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de precio y valoración
              Text("S/.${widget.tour['price']?.toString() ?? '0'} /por persona",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              RatingBarIndicator(
                rating: widget.avgRating,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20.0,
              ),
              Text("(${widget.tour['reviews']?.length ?? 0} Reseñas)"),

              // Sección para seleccionar el tipo de tour
              DropdownButtonFormField<String>(
                value: tourType,
                decoration: InputDecoration(labelText: 'Tipo de Tour'),
                onChanged: (newValue) {
                  setState(() {
                    tourType = newValue ?? tourType;
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

              // Campo para número de personas
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de personas'),
                keyboardType: TextInputType.number,
                controller:
                    guestSizeController, // Usa el TextEditingController aquí
              ),

              // Campo para teléfono
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                onChanged: (newValue) {
                  phone = newValue;
                },
              ),

              // Campos DNI
              SizedBox(
                height: 300, // Altura máxima del SingleChildScrollView
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      guestSize,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DniField(
                          index: index,
                          dni: dni,
                          setDni: (List<String?> newDniList) {
                            setState(() {
                              dni = newDniList.cast<String>();
                            });
                          },
                          userData: userData[index],
                          setUserData: (Map<String, dynamic> newUserData) {
                            setState(() {
                              userData[index] = newUserData;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Selector de fecha
              InkWell(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: bookAt ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != bookAt) {
                    setState(() {
                      bookAt = pickedDate;
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de reserva',
                      hintText: bookAt == null
                          ? 'Seleccione la fecha'
                          : DateFormat('yyyy-MM-dd').format(bookAt!),
                    ),
                  ),
                ),
              ),

              // Total a pagar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Total: S/.${totalAmount.toStringAsFixed(2)}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // Botón de reserva
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.redAccent, // Botón rojo, tema de la empresa
                  ),
                  onPressed: onReserve,
                  child: Text('COMPRAR', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
