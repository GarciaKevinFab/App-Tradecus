import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

const BASE_URL = "http://192.168.137.217:4000/api/v1";
const validDniLength = 8;
const httpOk = 200;

class DniField extends StatefulWidget {
  final int index;
  final List<String?> dni;
  final Function(List<String?>) setDni;
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) setUserData;

  DniField({
    Key? key,
    required this.index,
    required this.dni,
    required this.setDni,
    required this.userData,
    required this.setUserData,
  }) : super(key: key);

  @override
  _DniFieldState createState() => _DniFieldState();
}

class _DniFieldState extends State<DniField> {
  late TextEditingController _dniController;

  @override
  void initState() {
    super.initState();
    _dniController =
        TextEditingController(text: widget.dni[widget.index]?.toString() ?? '');
  }

  Future<void> fetchDniData() async {
    if (_dniController.text.length == validDniLength) {
      try {
        var response = await http
            .get(Uri.parse('$BASE_URL/dni/getDniData/${_dniController.text}'));
        if (response.statusCode == httpOk) {
          var data = json.decode(response.body);
          print(
              'Respuesta del servidor: $data'); // Imprime la respuesta del servidor
          if (data['nombres'] != null &&
              data['apellidoPaterno'] != null &&
              data['apellidoMaterno'] != null) {
            setState(() {
              widget.userData[widget.index.toString()] = data;
              widget.setUserData(widget.userData);
            });
          } else {
            Fluttertoast.showToast(msg: "Datos incompletos del servidor.");
          }
        } else {
          print('Código de estado HTTP no válido: ${response.statusCode}');
          Fluttertoast.showToast(msg: "Error en la respuesta del servidor.");
        }
      } catch (e) {
        print('Error al obtener los datos del DNI: $e');
        Fluttertoast.showToast(msg: "Error al obtener los datos del DNI: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "El DNI debe tener $validDniLength dígitos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _dniController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'DNI',
          ),
          onChanged: (value) {
            setState(() {
              widget.dni[widget.index] = value.toString();
              widget.setDni(widget.dni);
            });
          },
        ),
        ElevatedButton(
          onPressed: fetchDniData,
          child: Text('Validar'),
        ),
        if (widget.userData[widget.index.toString()] != null) ...[
          Text(
              'Nombres: ${widget.userData[widget.index.toString()]['nombres']}'),
          Text(
              'Apellidos: ${widget.userData[widget.index.toString()]['apellidoPaterno']} ${widget.userData[widget.index.toString()]['apellidoMaterno']}'),
        ],
      ],
    );
  }
}
