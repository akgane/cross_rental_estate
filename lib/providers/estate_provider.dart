import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/models/estate.dart';

class EstateProvider with ChangeNotifier{
  List<Estate> _estates = [];

  List<Estate> get estates => _estates;

  Future<void> loadEstates() async{
    try {
      final data = await fetchEstates();
      _estates = data;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading estates: $e");
      _estates = [];
      notifyListeners();
    }
  }

  Future<List<Estate>> fetchEstates() async{
    try {
      final snapshot = await FirebaseFirestore
          .instance
          .collection('estates')
          .get();

      return snapshot.docs.map((doc) => Estate.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching estates from Firestore: $e");
      return [];
    }
  }
}