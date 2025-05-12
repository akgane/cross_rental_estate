import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:rental_estate_app/models/category.dart';

class CategoryProvider with ChangeNotifier{
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> loadCategories() async{
    try{
      final data = await fetchCategories();
      _categories = data;
      notifyListeners();
    }catch(e){
      debugPrint("Error loading estates: $e");
      _categories = [];
      notifyListeners();
    }
  }

  Future<List<Category>> fetchCategories() async{
    try{
      final snapshot = await FirebaseFirestore
          .instance
          .collection('categories')
          .get();

      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    }catch(e){
      debugPrint("Error fetching categories from Firestore: $e");
      return [];
    }
  }
}