import 'package:flutter/material.dart';

final Map<String, Map<String, String>> fakeBooks = {
  "1": {
    "title": "El Quijote",
    "description": "Una novela clásica de Miguel de Cervantes"
  },
  "2": {
    "title": "1984",
    "description": "Distopía de George Orwell"
  }
};

// Pantalla de detalle del libro
class BookDetailScreen extends StatelessWidget {
  final String bookId;

  const BookDetailScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = fakeBooks[bookId];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del libro'),
      ),
      body: book == null
          ? Center(child: Text("Libro no encontrado"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book["title"]!,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    book["description"]!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      print("Reservado");
                    },
                    child: Text("Reservar"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Compra simulada 😄")),
                      );
                    },
                    child: Text("Comprar"),
                  ),
                ],
              ),
            ),
    );
  }
}