import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> books = [
  {'title': 'Harry Potter', 'author': 'J.K Rowling'},
  {'title': 'El Señor de los Anillos', 'author': 'Tolkien'},
  {'title': '1984', 'author': 'George Orwell'},
  {'title': 'El Principito', 'author': 'Saint-Exupéry'},
];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
  appBar: AppBar(
    title: const Text('Home 📚'),
    actions: [
      IconButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        icon: const Icon(Icons.logout),
      ),
    ],
  ),
  body: ListView.builder(
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];

      return Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(book['title']!),
          subtitle: Text(book['author']!),
          leading: const Icon(Icons.book),
        ),
      );
    },
  ),
);
  }
}