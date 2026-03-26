import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libreria_app/models/book.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore baseDatos = FirebaseFirestore.instance;

// Gestionar las operaciones con la base de datos para los libros

// Obtener la lista de libros desde la base de datos
Future<List<Book>> getBooks() async {
  try {
    QuerySnapshot snapshot = await baseDatos.collection("books").get();
    return snapshot.docs.map((doc) {
      return Book.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    debugPrint("Error: $e");
    return [];
  }
}

// Obtener un libro específico por su ID
Future<Book?> getBookById(String docId) async {
  DocumentSnapshot doc = await baseDatos.collection("books").doc(docId).get();
  if (doc.exists) {
    return Book.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  } else {
    return null;
  }
}

// Obtener la lista de libros con un Stream para actualizaciones en tiempo real
Stream<List<Book>> getBooksStream() {
  return baseDatos.collection("books").snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Book.fromFirestore(doc.id, doc.data())).toList();
  });
}

// Guardar un libro en la base de datos
Future<void> addBook(Map<String, dynamic> datosLibro) async {
  await baseDatos.collection("books").add({
    ...datosLibro,
    'createdAt': FieldValue.serverTimestamp(), // <-- siempre añadimos timestamp
  });
}

// Actualizar un libro en la base de datos
Future<void> updateBook(String docId, Map<String, dynamic> updatedData) async {
  await baseDatos.collection("books").doc(docId).update(updatedData);
}

// Eliminar un libro de la base de datos
Future<void> deleteBook(String docId) async {
  await baseDatos.collection("books").doc(docId).delete();
}

// Reservar un libro (marcarlo como no disponible)
Future<void> reserveBook(String docId) async {
  await baseDatos.collection("books").doc(docId).update({'isAvailable': false});
}

// Devolver un libro (marcarlo como disponible)
Future<void> returnBook(String docId) async {
  await baseDatos.collection("books").doc(docId).update({'isAvailable': true});
}

// Verificar si un libro está disponible
Future<bool> isBookAvailable(String docId) async {
  DocumentSnapshot doc = await baseDatos.collection("books").doc(docId).get();
  if (doc.exists) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return data['isAvailable'] ?? true;
  } else {
    throw Exception('El libro no esta disponible');
  }
}


// Gestion de usuarios en la base de datos


// Guardar email y UID de un usuario en la base de datos y asignarle el rol de "usuario"
Future<void> saveUserData(String uid, String email) async {
  await baseDatos.collection("users").doc(uid).set({
    'uid': uid,
    'email': email,
    'role': 'usuario', // Asignar el rol de "usuario"
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// Comprobar si un usuario es admin
Future<bool> isAdmin(String uid) async {
  DocumentSnapshot doc = await baseDatos.collection("users").doc(uid).get();
  if (doc.exists) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return data['role'] == 'admin';
  }
  return false;
}