import 'package:flutter/material.dart';
import 'package:libreria_app/firebase_service.dart';
import 'package:libreria_app/models/book.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
 
  const EditBookScreen({
    super.key,
    required this.book,
  });

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  //Controladores para capturar el texto
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _isbnController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _isbnController = TextEditingController(text: widget.book.isbn);
    _descriptionController = TextEditingController(text: widget.book.description);
    _priceController = TextEditingController(text: widget.book.price.toString());
    _stockController = TextEditingController(text: widget.book.stock.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  //Función actualizar el libro
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);  //desactivamos el botón mientras se guarda
      try {
        final updatedBook = widget.book.copyWith(
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          isbn: _isbnController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.tryParse(_priceController.text) ?? 0.0,
          stock: int.tryParse(_stockController.text) ?? 0,
        );

        await updateBook(updatedBook.docId, updatedBook.toFirestore());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Libro actualizado correctamente')),
          );
          Navigator.pop(context); // Volver atrás al terminar
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e')),
          );
        }
      }
      finally {
        if (mounted) setState(() => _isSaving = false);  // Volvemos a activar el botón después de guardar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Libro 📖')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título:'),
                validator: (value) => value!.isEmpty ? 'Pon un título' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Autor:'),
                validator: (value) => value!.isEmpty ? 'Pon un autor' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN:'),
                validator: (value) => value!.isEmpty ? 'Pon un ISBN' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio (€):'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Pon un precio';
                  if (double.tryParse(value) == null){
                    return 'El precio no es válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Existencias:'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.trim().isEmpty ? '¿Cuantas existencias hay?' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null :_saveChanges,  // Desactivamos el botón mientras se guarda
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text('Actualizar libro', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
