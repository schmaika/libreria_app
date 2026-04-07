import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String author;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(author),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 400,
                      width: 300,
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: DateTime.now(),
                        onDaySelected: (selectedDay, focusedDay) {
                          // 1. Cerramos el calendario
                          Navigator.pop(context);

                          // 2. Mostramos el mensaje de confirmación
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Reserva realizada para el: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              child: const Text("Reservar Ahora"),
            ),
          ],
        ),
      ),
    );
  }
}
