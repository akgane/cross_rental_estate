import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/services/connectivity_service.dart';
import 'package:rental_estate_app/services/offline_storage_service.dart';

class EstateProvider with ChangeNotifier {
  List<Estate> _estates = [];
  final ConnectivityService _connectivityService;
  final OfflineStorageService _offlineStorage;
  bool _isOffline = false;

  EstateProvider(this._connectivityService, this._offlineStorage) {
    _initConnectivityListener();
  }

  List<Estate> get estates => _estates;
  bool get isOffline => _isOffline;

  void _initConnectivityListener() {
    _connectivityService.onConnectivityChanged.listen((isConnected) {
      _isOffline = !isConnected;
      if (isConnected) {
        loadEstates(); // Reload from network when connection is restored
      }
      notifyListeners();
    });
  }

  Future<void> loadEstates() async {
    try {
      final isConnected = await _connectivityService.isConnected();
      if (isConnected) {
        final data = await fetchEstates();
        _estates = data;
        // Cache the estates for offline use
        await _offlineStorage.saveEstates(data);
      } else {
        // Load from offline storage
        _estates = await _offlineStorage.getOfflineEstates();
      }
      _isOffline = !isConnected;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading estates: $e");
      // Try to load from offline storage in case of error
      _estates = await _offlineStorage.getOfflineEstates();
      _isOffline = true;
      notifyListeners();
    }
  }

  Future<List<Estate>> fetchEstates() async {
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