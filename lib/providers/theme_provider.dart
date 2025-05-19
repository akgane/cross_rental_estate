import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';

class ThemeProvider with ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get currentTheme => _themeMode;

  void toggleTheme(BuildContext context){
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null && !authProvider.isGuest) {
      authProvider.user!.theme = _themeMode == ThemeMode.light ? 'ThemeMode.light' : 'ThemeMode.dark';
      authProvider.updateUserInfo();
    }
  }

  void initTheme(String theme){
    final newTheme = _parseThemeString(theme);
    if (_themeMode != newTheme) {
      _themeMode = newTheme;
      notifyListeners();
    }
  }

  void setTheme(String theme){
    _themeMode = _parseThemeString(theme);
    notifyListeners();
  }

  ThemeMode _parseThemeString(String theme) {
    switch (theme) {
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.light':
      default:
        return ThemeMode.light;
    }
  }
}