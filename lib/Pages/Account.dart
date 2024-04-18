import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'RegisterPage.dart'; // Importa la página de registro
import '../components/Layout/Layout.dart';
import 'Home.dart';
import 'UserProfile.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final String BASE_URL = 'http://192.168.137.217:4000/api/v1/usermobile';
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> login(String email, String password) async {
    final Uri url = Uri.parse('$BASE_URL/login');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token);

      // Navegar a la pantalla deseada después del inicio de sesión exitoso
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfile()),
      );
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      bodyContent: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          InputDecoration(labelText: 'Correo electrónico'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Es necesario un email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es obligatoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login(
                            _emailController.text,
                            _passwordController.text,
                          ).catchError((error) {
                            // Show error message to the user
                            print(error);
                          });
                        }
                      },
                      child: Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: register,
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
