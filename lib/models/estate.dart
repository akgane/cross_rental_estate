import 'package:cloud_firestore/cloud_firestore.dart';

class Estate {
  final String uid;
  final String title;
  final String description;
  final double price;
  final String location;
  final List<String> imageUrls;
  final String category;
  final String ownerId;
  final DateTime createdAt;

  Estate({
    required this.uid,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.imageUrls,
    required this.category,
    required this.ownerId,
    required this.createdAt,
  });

  Estate copyWith() {
    return Estate(
      uid: uid,
      title: title,
      description: description,
      price: price,
      location: location,
      imageUrls: imageUrls,
      category: category,
      ownerId: ownerId,
      createdAt: createdAt,
    );
  }

  factory Estate.fromFirestore(Map<String, dynamic> data, String uid) {
    return Estate(
      uid: uid,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      location: data['location'] ?? '',
      imageUrls: List<String>.from(data['image-urls'] ?? []),
      category: data['category'] ?? '',
      ownerId: data['owner-id'] ?? '',
      createdAt: (data['created-at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'image-urls': imageUrls,
      'category': category,
      'owner-id': ownerId,
      'created-at': Timestamp.fromDate(createdAt),
    };
  }

  // Методы для сериализации в JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'image-urls': imageUrls,
      'category': category,
      'owner-id': ownerId,
      'created-at': createdAt.toIso8601String(),
    };
  }

  factory Estate.fromJson(Map<String, dynamic> json) {
    return Estate(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      location: json['location'],
      imageUrls: List<String>.from(json['image-urls']),
      category: json['category'],
      ownerId: json['owner-id'],
      createdAt: DateTime.parse(json['created-at']),
    );
  }
}
