import 'dart:convert';
import 'package:rental_estate_app/models/estate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineStorageService {
  static const String ESTATES_KEY = 'offline_estates';
  final SharedPreferences _prefs;

  OfflineStorageService(this._prefs);

  Future<void> saveEstates(List<Estate> estates) async {
    final List<Map<String, dynamic>> estatesData = estates.map((estate) => {
      'uid': estate.uid,
      'title': estate.title,
      'category': estate.category,
      'address': estate.address,
      'price': estate.price,
      'views': estate.views,
      'features': estate.features,
      'postedDate': estate.postedDate.toIso8601String(),
    }).toList();

    await _prefs.setString(ESTATES_KEY, jsonEncode(estatesData));
  }

  Future<List<Estate>> getOfflineEstates() async {
    final String? estatesJson = _prefs.getString(ESTATES_KEY);
    if (estatesJson == null) return [];

    final List<dynamic> estatesData = jsonDecode(estatesJson);
    return estatesData.map((data) => Estate(
      uid: data['uid'],
      title: data['title'],
      category: data['category'],
      address: data['address'],
      imageUrls: [], // Empty list for offline mode
      price: data['price'].toDouble(),
      views: data['views'],
      features: Map<String, dynamic>.from(data['features']),
      postedDate: DateTime.parse(data['postedDate']),
    )).toList();
  }

  Future<void> clearOfflineData() async {
    await _prefs.remove(ESTATES_KEY);
  }
} 