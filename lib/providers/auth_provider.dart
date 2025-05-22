import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/services/auth_service.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _isLoading = false;
  bool _isGuest = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    debugPrint("login as user");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.loginWithEmail(email, password);
      _isGuest = false;
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

    try {
      _user = await _authService.loginAsGuest();
      _isGuest = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
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

  Future<void> reloadUser(String userId) async {
    debugPrint("Reloading user with ID: $userId");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.getUserById(userId);
      _isGuest = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUsername(String newUsername) async {
    if (_user == null || _isGuest) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.updateUsername(_user!.uid, newUsername);
      _user!.username = newUsername;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmail(String newEmail) async {
    if (_user == null || _isGuest) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.updateEmail(_user!.uid, newEmail);
      _user!.email = newEmail;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
