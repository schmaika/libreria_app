import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Importamos las pantallas de las carpetas correspondientes
import 'package:libreria_app/screens/Auth_screen.dart';
import 'package:libreria_app/screens/home_screen.dart';
import 'package:libreria_app/screens/calendar_page.dart';

void main() async {
  // 1. Asegurar que Flutter esté listo antes de iniciar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Arranca la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librería App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
