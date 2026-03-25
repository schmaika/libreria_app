import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario logueado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reservas 📚'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error cargando reservas'));
          }

          final reservations = snapshot.data?.docs ?? [];

          if (reservations.isEmpty) {
            return const Center(child: Text('No tienes reservas aún'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final data = reservations[index].data() as Map<String, dynamic>;

              final title = data['title'] ?? 'Sin título';
              final returnDate = data['returnDate'] ?? 'Sin fecha';

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(title),
                  subtitle: Text('Devolver antes de: $returnDate'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}