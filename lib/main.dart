import 'package:flutter/material.dart' show MaterialApp, runApp;
import 'screens/home_screen.dart'; // Asegúrate de que esta ruta sea correcta

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(), // Esto abre tu lista de libros
  ));
}
