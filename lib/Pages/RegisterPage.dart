import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../auth_provider.dart'; // Importa AuthProvider desde su ubicación

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String BASE_URL = 'http://192.168.137.217:4000/api/v1/usermobile';
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> register(String username, String email, String password) async {
    print(
        'Attempting to register user with username: $username, email: $email');
    final Uri url = Uri.parse('$BASE_URL/register');
    final response = await http.post(
      url,
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    print('HTTP status code: ${response.statusCode}');
    print('HTTP response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Registration successful for user: $username');
      Provider.of<AuthProvider>(context, listen: false)
          .registerSuccess(context);
    } else {
      final responseData = jsonDecode(response.body);
      print('Registration failed with error: ${responseData['message']}');
      Fluttertoast.showToast(msg: responseData['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Es obligatorio una contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    register(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    ).catchError((error) {
                      print('Error during registration: $error');
                      Fluttertoast.showToast(msg: error.toString());
                    });
                  }
                },
                child: Text('Registrarse'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('¿Ya tienes una cuenta? Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
