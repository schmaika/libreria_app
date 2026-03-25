import 'package:flutter/material.dart';
import 'package:libreria_app/firebase_service.dart';
import 'package:libreria_app/screens/edit_Book_Screen.dart';

class BookDetailScreen extends StatelessWidget {
  final String docId;
  final String isbn;
  final String title;
  final String author;
  final String description;
  //final String imageUrl;
  final double price;
  final bool isAvailable;

  const BookDetailScreen({
    super.key,
    required this.docId,
    required this.isbn,
    required this.title,
    required this.author,
    required this.description,
    //required this.imageUrl,
    required this.price,
    required this.isAvailable,
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
              onPressed: () {},
              child: const Text('Reservar'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Comprar'),
            ),
            
            const SizedBox(height: 10),
            //Botón para editar la información del libro (solo para admin)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => EditBookScreen(
                  docId: docId,
                  title: title,
                  author: author,
                  isbn: isbn,
                  price: price,
                )));
              },
              child: const Text('Editar Información'),
            ),
            const SizedBox(height: 10),

            //Botón para eliminar el libro con confirmación
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Eliminar libro'),
                    content: Text(
                        '¿Estás seguro de que quieres eliminar "$title"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Eliminar',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await deleteBook(docId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Libro eliminado correctamente')),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Borrar Libro'),
            ),
          ],
        ),
      ),
    );
  }
}
