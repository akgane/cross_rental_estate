import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/services/auth_service.dart';
import 'package:rental_estate_app/services/session_service.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  SessionService? _sessionService;
  
  AppUser? _user;
  bool _isLoading = true; // Changed to true by default
  bool _isGuest = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  String? get error => _error;

  // Инициализация провайдера и проверка сохраненной сессии
  Future<void> initializeSession() async {
    if (_sessionService != null) return; // Prevent multiple initializations
    
    try {
      _sessionService = await SessionService.getInstance();
      
      if (_sessionService!.isLoggedIn) {
        final userId = _sessionService!.userId;
        if (userId != null) {
          _user = await _authService.getUserData(userId);
          _isGuest = false;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    debugPrint("login as user");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.loginWithEmail(email, password);
      _isGuest = false;
      // Сохраняем сессию после успешного входа
      await _sessionService?.saveSession(userId: _user!.uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String username) async {
    debugPrint("registering");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.registerWithEmail(email, password, username);
      _isGuest = false;
      // Сохраняем сессию после успешной регистрации
      await _sessionService?.saveSession(userId: _user!.uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginAsGuest() async {
    debugPrint("loging as guest");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.loginAsGuest();
      _isGuest = true;
      // Очищаем сессию при входе как гость
      await _sessionService?.clearSession();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // Очищаем сессию при выходе
    await _sessionService?.clearSession();
    _user = null;
    notifyListeners();
  }

  Future<void> updateUserInfo() async {
    print("1 updateUserInfo");
    if (_user == null || _isGuest) return;
    print("updateUserInfo");
    try {
      await _authService.updateUser(_user!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
