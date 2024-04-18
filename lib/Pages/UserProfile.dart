import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart'; // Importa el proveedor de autenticación

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider
        .currentUser; // Suponiendo que tienes un método para obtener el usuario actual en tu proveedor

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nombre de usuario: ${user.username}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Correo electrónico: ${user.email}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authProvider
                    .logout(context); // Pasar el contexto como argumento
              },
              style: ElevatedButton.styleFrom(
                // Usar color para personalizar el botón
                backgroundColor: Color.fromARGB(255, 228, 89, 24),
              ),
              child: Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
