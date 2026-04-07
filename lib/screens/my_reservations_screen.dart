import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
      body: FutureBuilder(
        future: initializeDateFormatting('es'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
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
                  final doc = reservations[index];
                  final data = doc.data() as Map<String, dynamic>;

                  final title = data['title'] ?? 'Sin título';

                  String formattedDate = 'Sin fecha';
                  bool isExpired = false;

                  if (data['returnDate'] != null) {
                    final date = DateTime.parse(data['returnDate']);
                    formattedDate =
                        DateFormat('d MMMM', 'es').format(date);

                    final now = DateTime.now();
                    isExpired = now.isAfter(date);
                  }

                  return Card(
                    color: isExpired ? Colors.red[100] : null,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(title),

                      subtitle: Text(
                        isExpired
                            ? 'Reserva vencida ❌'
                            : 'Devolver antes de: $formattedDate',
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancelar reserva'),
                              content: const Text('¿Estás seguro?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Sí'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('reservations')
                                .doc(doc.id)
                                .delete();

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reserva cancelada 🗑️'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}