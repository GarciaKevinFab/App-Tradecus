import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart'; // Importa el proveedor de autenticación
import '../../Pages/UserProfile.dart'; // Importa la página UserProfile.dart
import '../../Pages/Account.dart'; // Importa la página de inicio de sesión

class Footer extends StatelessWidget {
  final List<Map<String, dynamic>> navLinks = [
    {'icon': Icons.home, 'path': '/home'},
    {'icon': Icons.info, 'path': '/about'},
    {'icon': Icons.map, 'path': '/tours'},
    {'icon': Icons.login, 'path': '/account'},
  ];

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en el AuthProvider
    final authProvider =
        Provider.of<AuthProvider>(context); // listen: true por defecto
    final isLoggedIn = authProvider.currentUser.username.isNotEmpty;

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navLinks.map((item) {
          Widget iconButton;
          if (item['path'] == '/account') {
            // Cambia el ícono y la acción dependiendo del estado de sesión
            iconButton = IconButton(
              icon: Icon(isLoggedIn ? Icons.person : Icons.login),
              onPressed: () {
                if (isLoggedIn) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserProfile()),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                }
              },
            );
          } else {
            iconButton = IconButton(
              icon: Icon(item['icon']),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  item['path'],
                  ModalRoute.withName('/home'),
                );
              },
            );
          }
          return iconButton;
        }).toList(),
      ),
    );
  }
}
