import 'package:flutter/material.dart';
import 'package:libreria_app/firebase_service.dart';

class EditBookScreen extends StatefulWidget {
  final String docId;
  final String title;
  final String author;
  final String isbn;
  final double price;
 
  const EditBookScreen({
    super.key,
    required this.docId,
    required this.title,
    required this.author,
    required this.isbn,
    required this.price,
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
  late TextEditingController _priceController;

   bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _authorController = TextEditingController(text: widget.author);
    _isbnController = TextEditingController(text: widget.isbn);
    _priceController = TextEditingController(text: widget.price.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  //Función actualizar el libro
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await updateBook(widget.docId, {
          'title': _titleController.text.trim(),
          'author': _authorController.text.trim(),
          'isbn': _isbnController.text.trim(),
          'price': double.tryParse(_priceController.text) ?? 0.0,
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Libro actualizado correctamente')),
          );
          Navigator.pop(context); // Volver atrás al terminar
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
      finally {
        if (mounted) setState(() => _isSaving = false);
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
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
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
