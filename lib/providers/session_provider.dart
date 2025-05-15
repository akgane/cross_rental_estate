import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/session_service.dart';

class SessionProvider with ChangeNotifier {
  late final SessionService _sessionService;
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  bool get isInitialized => _isInitialized;

  SessionProvider() {
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionService = SessionService(prefs);
    _isLoggedIn = _sessionService.isLoggedIn;
    _userId = _sessionService.userId;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> login(String userId) async {
    await _sessionService.saveSession(userId: userId);
    _isLoggedIn = true;
    _userId = userId;
    notifyListeners();
  }

  Future<void> logout() async {
    await _sessionService.clearSession();
    _isLoggedIn = false;
    _userId = null;
    notifyListeners();
  }
}