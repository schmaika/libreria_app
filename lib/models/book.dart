import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String docId; // El ID que genera Firebase
  final String isbn;
  final String title;
  final String author;
  final String category;
  final String description;
  //final String imageUrl;
  final double price;
  final int stock;
  final DateTime? createdAt;

  Book({
    required this.docId,
    required this.isbn,
    required this.title,
    this.author = 'Anónimo',
    this.category = 'Sin categoría',
    required this.description,
    //required this.imageUrl,
    required this.price,
    required this.stock,
    this.createdAt,
  });

  // Convierte un DocumentSnapshot de Firebase a un objeto Book
  factory Book.fromFirestore(String docId, Map<String, dynamic> data) {
    return Book(
      docId: docId,
      isbn: data['isbn'] ?? '',
      title: data['title'] ?? 'Sin título',
      author: data['author'] ?? 'Anónimo',
      category: data['category'] ?? 'Sin categoría',
      description: data['description'] ?? '',
      //imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      stock: data['stock'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convierte un objeto Book a un Map para enviarlo a Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'isbn': isbn,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      //'imageUrls': imageUrl,
      'price': price,
      'stock': stock,
      'createdAt': createdAt,
    };
  }

  Book copyWith({
    String? isbn,
    String? title,
    String? author,
    String? category,
    String? description,
    double? price,
    int? stock,
    DateTime? createdAt,
  }) {
    return Book(
      docId: docId,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}