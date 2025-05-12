import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;

  Category({required this.title, required this.icon});

  static IconData? _mapStringToIcon(String? iconName) {
    switch (iconName) {
      case 'Icons.home':
        return Icons.home;
      case 'Icons.business':
        return Icons.business;
      case 'Icons.apartment':
        return Icons.apartment;
      case 'Icons.villa':
        return Icons.villa;
      default:
        return Icons.not_interested; // Default fallback icon
    }
  }

  factory Category.fromFirestore(DocumentSnapshot data) {
    return Category(
      title: data['title'] ?? 'Unknown Category',
      icon: _mapStringToIcon(data['icon'] as String?) ?? Icons.not_interested,
    );
  }
}
