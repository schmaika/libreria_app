import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libreria_app/firebase_service.dart';
import 'package:libreria_app/models/book.dart';
import 'package:libreria_app/screens/add_Book_Screen.dart';
import 'package:libreria_app/firebase_service.dart';
import 'package:libreria_app/models/book.dart';
import 'package:libreria_app/screens/add_book_screen.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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

      body: StreamBuilder<List<Book>>(
        stream: getBooksStream(),
      body: StreamBuilder<List<Book>>(
        stream: getBooksStream(),
        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return const Center(child: Text('Error cargando libros'));
          }

          final books = snapshot.data ?? [];
          final books = snapshot.data ?? [];

          // Sin datos
          if (books.isEmpty) {
            return const Center(child: Text('No hay libros aún'));
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final book = books[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(
                        docId: book.docId!,
                        title: book.title,
                        author: book.author,
                        isbn: book.isbn,
                        description: book.description,
                        //imageUrl: book.imageUrl,
                        price: book.price,
                        isAvailable: book.isAvailable,
                        docId: book.docId!,
                        title: book.title,
                        author: book.author,
                        isbn: book.isbn,
                        description: book.description,
                        //imageUrl: book.imageUrl,
                        price: book.price,
                        isAvailable: book.isAvailable,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              book.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      //Botón para añadir un nuevo libro
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddBookScreen()),
      );
      },
      child: const Icon(Icons.add),
      ),
    );
  }
}
