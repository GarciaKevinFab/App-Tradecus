import 'package:flutter/material.dart';
import '../Pages/Account.dart';
import '../Pages/UserProfile.dart';

class AuthProvider with ChangeNotifier {
  late User _currentUser; // Propiedad para almacenar el usuario actual

  // Constructor
  AuthProvider() {
    _currentUser = User(); // Inicializa el usuario actual
  }

  // Método para obtener el usuario actual
  User get currentUser => _currentUser;

  // Método para establecer el usuario actual
  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Método para cerrar la sesión
  void logout(BuildContext context) {
    // Aquí puedes agregar lógica adicional, como limpiar datos de sesión, etc.
    _currentUser = User(); // Reinicia el usuario actual a uno nuevo vacío
    notifyListeners();

    // Redirige a la página de inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(),
      ),
    );
  }

  void registerSuccess(BuildContext context) {
    // Lógica para manejar el estado del registro exitoso
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserProfile(), // Redirige al UserProfile después de iniciar sesión
      ),
    );
  }

  // Añade otros métodos según necesites
}

class User {
  String username = '';
  String email = '';

  User({this.username = '', this.email = ''});
}
