import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libreria_app/firebase_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  //Controladores para capturar el texto
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _isbnController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  //Función para guardar los datos del libro
  Future<void> _saveBook() async {
    if ( _formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await addBook({
          'isbn': _isbnController.text.trim(),
          'title': _titleController.text.trim(),
          'author': _authorController.text.trim(),
          'category': _categoryController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'stock': int.tryParse(_stockController.text) ?? 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        if (mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Libro añadido correctamente')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
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
      appBar: AppBar(title: const Text('Nuevo Libro 📖')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (value) => value!.isEmpty ? 'Pon un ISBN' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Pon un título' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) => value!.isEmpty ? 'Pon un autor' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) => value!.isEmpty ? 'Pon una categoría (opcional)' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio (€)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Pon un precio';
                  if (double.tryParse(value) == null){
                    return 'El precio no es válido';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Existencias (opcional)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.trim().isEmpty ? '¿Cuantas existencias hay?' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveBook,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text('Guardar Libro', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
