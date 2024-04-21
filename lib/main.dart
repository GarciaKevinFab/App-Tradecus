import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './auth_provider.dart'; // Asegúrate de que la ruta es correcta
import './Pages/Home.dart';
import './Pages/About.dart';
import './Pages/Tours.dart';
import './Pages/SearchResultList.dart';
import './Pages/ThankYou.dart';
import './Pages/Account.dart';
import './Pages/UserProfile.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter App',
        initialRoute: '/home',
        routes: {
          '/': (context) => HomePage(),
          '/home': (context) => HomePage(),
          '/about': (context) => AboutPage(),
          '/tours': (context) => ToursPage(),
          '/thank-you': (context) => ThankYouPage(),
          '/search-results': (context) => SearchResultListPage(),
          '/account': (context) => AccountPage(),
          '/profile': (context) => UserProfile(),
        },
      ),
    );
  }
}
