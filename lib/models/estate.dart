import 'package:cloud_firestore/cloud_firestore.dart';

class Estate {
  final String uid;
  final String title;
  final String category;
  final String address;
  final List<String> imageUrls;
  final int views;
  final double price;
  final Map<String, dynamic> features;
  final DateTime postedDate;

  Estate({
    required this.uid,
    required this.title,
    required this.category,
    required this.address,
    required this.imageUrls,
    this.views = 0,
    required this.price,
    required this.features,
    required this.postedDate,
  });

  Estate copyWith() {
    return Estate(
      uid: uid,
      title: title,
      category: category,
      address: address,
      imageUrls: imageUrls,
      views: views,
      price: price,
      features: features,
      postedDate: postedDate,
    );
  }

  factory Estate.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parsePostedDate(dynamic dateData) {
      if (dateData is String) {
        return DateTime.parse(dateData);
      } else if (dateData is Timestamp) {
        return dateData.toDate();
      } else {
        return DateTime.now();
      }
    }

    return Estate(
      uid: doc.id,
      title: data['title'] ?? 'No title',
      category: data['category'] ?? 'Unknown',
      address: data['address'] ?? 'No Address',
      imageUrls:
          data['image-urls'] ??
          (data['imageUrl'] != null ? [data['imageUrl']] : []),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      postedDate: parsePostedDate(data['postedDate']),
      features: Map<String, dynamic>.from(data['features'] ?? {}),
      views: (data['views'] as num?)?.toInt() ?? 0,
    );
  }
}
