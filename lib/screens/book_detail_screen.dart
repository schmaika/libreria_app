import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(author),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) return;

                      final now = DateTime.now();
                      final returnDate = now.add(const Duration(days: 14));

                      // Comprobar si ya existe reserva
                      final existing = await FirebaseFirestore.instance
                            .collection('reservations')
                            .where('userId', isEqualTo: user.uid)
                            .where('title', isEqualTo: title)
                            .get();

                      if (existing.docs.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ya has reservado este libro'))
                        );
                        return;
                      }

                      // Guardar si no existe
                      await FirebaseFirestore.instance.collection('reservations').add({
                        'title': title,
                        'author': author,
                        'userId': user.uid,
                        'reservationDate': now.toString(),
                        'returnDate': returnDate.toString(), 
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reserva guardada 🔥')),
                      );
                    },
                    child: const Text('Reservar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Compra no disponible aún 💸'),
                        ),
                      );
                    },
                    child: const Text('Comprar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}