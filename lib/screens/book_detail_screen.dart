import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.book, size: 100),
            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              author,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('reservations').add({
                  'title': title,
                  'author': author,
                  'date': DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva guardada 🔥')),
    );
  },
  child: const Text('Reservar'),
),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}