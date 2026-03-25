import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String author;

  BookDetailScreen({required this.title, required this.author});

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
            Text(title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(author),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 400,
                      width: 300,
                      child: TableCalendar(
                        firstDay: DateTime.utc(2024, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: DateTime.now(),
                        onDaySelected: (selectedDay, focusedDay) {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                );
              },
              child: Text("Reservar Ahora"),
            ),
          ],
        ),
      ),
    );
  }
}
