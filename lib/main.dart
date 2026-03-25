import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'screens/home_screen.dart'; // Asegúrate de que esta ruta sea correcta

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(), // Esto abre tu lista de libros
  ));
}
