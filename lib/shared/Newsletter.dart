import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const BASE_URL = "http://192.168.137.217:4000/api/v1";
const primaryColor =
    Color.fromARGB(255, 228, 89, 24); // Definir el color principal

class Newsletter extends StatefulWidget {
  @override
  _NewsletterState createState() => _NewsletterState();
}

class _NewsletterState extends State<Newsletter> {
  final TextEditingController _emailController = TextEditingController();
  String? _message;
  bool _isLoading = false;

  Future<void> _subscribe(String email) async {
    if (email.isEmpty) {
      setState(() {
        _message = 'Por favor ingrese un email válido.';
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse('$BASE_URL/subscribe');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _message = '¡Gracias por suscribirte!';
        });
      } else {
        setState(() {
          _message =
              json.decode(response.body)['message'] ?? 'Error desconocido.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Algo salió mal. Inténtalo de nuevo.';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _emailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suscríbete para recibir Ofertas.',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: primaryColor),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese su email',
                        suffixIcon: Icon(Icons.email, color: primaryColor),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _subscribe(_emailController.text),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Suscribir'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                    ),
                    if (_message != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(_message!,
                            style: TextStyle(color: Colors.red)),
                      )
                  ],
                ),
              ),
              Expanded(
                child: Image.asset('assets/images/male-tourist.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
