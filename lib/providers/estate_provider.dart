import 'package:flutter/material.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/services/cache_service.dart';
import 'package:rental_estate_app/services/connectivity_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EstateProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();
  CacheService? _cacheService;
  
  List<Estate> _estates = [];
  bool _isLoading = true;
  String? _error;
  bool _isOffline = false;

  List<Estate> get estates => _estates;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;

  EstateProvider() {
    _connectivityService.onConnectivityChanged.listen((isConnected) {
      _isOffline = !isConnected;
      if (isConnected) {
        loadEstates(); // Обновляем данные при восстановлении соединения
      }
      notifyListeners();
    });
  }

  Future<void> loadEstates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Инициализируем сервис кэширования при первой загрузке
      _cacheService ??= await CacheService.getInstance();

      if (_connectivityService.isConnected) {
        // Если есть интернет, загружаем с сервера
        final QuerySnapshot snapshot = await _firestore.collection('estates').get();
        _estates = snapshot.docs
            .map((doc) => Estate.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        // Кэшируем полученные данные
        await _cacheService?.cacheEstates(_estates);
        _isOffline = false;
      } else {
        // Если нет интернета, загружаем из кэша
        final cachedEstates = _cacheService?.getCachedEstates();
        if (cachedEstates != null) {
          _estates = cachedEstates;
        }
        _isOffline = true;
      }
    } catch (e) {
      _error = e.toString();
      // В случае ошибки пытаемся загрузить из кэша
      final cachedEstates = _cacheService?.getCachedEstates();
      if (cachedEstates != null) {
        _estates = cachedEstates;
        _isOffline = true;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Получение плейсхолдера для изображения
  String getImageUrl(String originalUrl) {
    if (_isOffline) {
      return 'assets/images/placeholder.png'; // Путь к локальному плейсхолдеру
    }
    return originalUrl;
  }
}