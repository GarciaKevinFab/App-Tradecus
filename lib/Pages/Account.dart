import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth_provider.dart';
import 'RegisterPage.dart';
import 'UserProfile.dart';
import 'Home.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final String BASE_URL = 'http://192.168.137.217:4000/api/v1/usermobile';
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late DecorationImage backgroundImage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Asegúrate de que 'assets/logo.png' se refiera al camino correcto donde tienes tu logo.
    backgroundImage = DecorationImage(
      image: AssetImage('assets/images/logo.png'),
      fit: BoxFit.none,
      scale: 5.0,
      opacity: 0.1,
    );
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

      // Actualiza el estado del usuario en AuthProvider
      Provider.of<AuthProvider>(context, listen: false).setCurrentUser(User(
              username: email,
              email: email) // Suponiendo que estos son los datos que tienes
          );

      Fluttertoast.showToast(
        msg: "Sesión iniciada",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('INICIO DE SESIÓN'),
        elevation: 0,
        backgroundColor:
            Colors.white, // o cualquier color que prefieras para el AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.red.shade900,
              height: 4.0,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: backgroundImage,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
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
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Es necesario un email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La contraseña es obligatoria';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(
                              _emailController.text,
                              _passwordController.text,
                            ).catchError((error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Error al iniciar sesión: $error'),
                                backgroundColor: Colors.red.shade900,
                              ));
                            });
                          }
                        },
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                  ),
                  onPressed: register,
                  child: Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
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
