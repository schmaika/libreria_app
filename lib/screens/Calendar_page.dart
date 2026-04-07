import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Libros'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              try {
                await FirebaseFirestore.instance
                    .collection('reservations')
                    .add({
                  'title': 'Reserva de Libro',
                  'date': selectedDay,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Reserva enviada a Firebase! 🚀'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                print("Error: $e");
              }
              try {
                await FirebaseFirestore.instance
                    .collection('reservations')
                    .add({
                  'title': 'Libro Reservado',
                  'date': selectedDay,
                  'createdAt': FieldValue.serverTimestamp(),
                  'status': 'confirmada',
                });
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reserva guardada: ${selectedDay.day}/${selectedDay.month}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                print("Error: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al guardar'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            // Estilo del calendario
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDay == null
                        ? "Selecciona un día para reservar"
                        : "Disponibilidad para: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_selectedDay != null)
                    ElevatedButton(
                      onPressed: () {
                        // Conectar con Firebase más adelante
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Buscando libros disponibles...'),
                          ),
                        );
                      },
                      child: const Text('Confirmar Fecha de Reserva'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
