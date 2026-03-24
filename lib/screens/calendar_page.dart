// Archivo: lib/screens/calendar_page.dart
// Responsable: JoseM (feature/calendar)
// Módulo: Interfaz de Calendario
// Proyecto: Prácticas Zzzaitec

import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Variable para gestionar el día que el usuario selecciona en el calendario
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Calendario'),
        backgroundColor: Colors.teal, // Color distinto al de Mike para diferenciar
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Cabecera informativa del módulo
              const Text(
                'Gestión de Fechas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Selecciona un día para gestionar eventos o disponibilidad.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // CONTENEDOR DEL CALENDARIO
              // Aquí es donde JoseM implementará el widget TableCalendar o similar
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Simulación de cabecera de calendario (Mes y Año)
                    const ListTile(
                      leading: Icon(Icons.arrow_back_ios, size: 15),
                      title: Center(
                        child: Text(
                          'Marzo 2026',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    ),
                    const Divider(),
                    // Placeholder de la cuadrícula de días
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: 31,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botón de acción para confirmar la fecha seleccionada
              ElevatedButton.icon(
                onPressed: () {
                  // Acción para cuando el usuario confirma la fecha
                },
                icon: const Icon(Icons.check),
                label: const Text('Confirmar Fecha Seleccionada'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}