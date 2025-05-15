import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  
  final SharedPreferences _prefs;
  
  SessionService(this._prefs);
  
  // Сохранение данных сессии
  Future<void> saveSession({required String userId}) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_userIdKey, userId);
  }
  
  // Проверка, залогинен ли пользователь
  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;
  
  // Получение ID пользователя
  String? get userId => _prefs.getString(_userIdKey);
  
  // Очистка данных сессии при выходе
  Future<void> clearSession() async {
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_userIdKey);
  }
}