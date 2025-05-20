import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  
  final SharedPreferences _prefs;
  
  SessionService(this._prefs);
  
  Future<void> saveSession({required String userId}) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_userIdKey, userId);
  }
  
  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;
  
  String? get userId => _prefs.getString(_userIdKey);
  
  Future<void> clearSession() async {
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_userIdKey);
  }
}