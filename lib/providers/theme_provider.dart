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
      authProvider.user!.theme = _themeMode.toString();
      authProvider.updateUserInfo();
    }
  }

  void initTheme(String theme){
    _themeMode = (theme == ThemeMode.light.toString() ? ThemeMode.light : ThemeMode.dark);
  }

  void setTheme(String theme){
    _themeMode = (theme == ThemeMode.light.toString() ? ThemeMode.light : ThemeMode.dark);
    notifyListeners();
  }
}