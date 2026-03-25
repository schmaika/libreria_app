class Book {
  final String? docId; // El ID que genera Firebase
  final String isbn;
  final String title;
  final String author;
  final String description;
  //final String imageUrl;
  final double price;
  final bool isAvailable;

  Book({
    this.docId,
    required this.isbn,
    required this.title,
    required this.author,
    required this.description,
    //required this.imageUrl,
    required this.price,
    this.isAvailable = true,
  });

  // Convierte un DocumentSnapshot de Firebase a un objeto Book
  factory Book.fromFirestore(String docId, Map<String, dynamic> data) {
    return Book(
      docId: docId,
      isbn: data['isbn'] ?? '',
      title: data['title'] ?? 'Sin título',
      author: data['author'] ?? 'Anónimo',
      description: data['description'] ?? '',
      //imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  // Convierte un objeto Book a un Map para enviarlo a Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'isbn': isbn,
      'title': title,
      'author': author,
      'description': description,
      //'imageUrls': imageUrl,
      'price': price,
      'isAvailable': isAvailable,
    };
  }
}
