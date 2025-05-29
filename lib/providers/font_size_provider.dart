import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider with ChangeNotifier {
  double _fontSize = 1.0; // 1.0 is normal size
  static const String _fontSizeKey = 'fontSize';

  FontSizeProvider() {
    _loadFontSize();
  }

  double get fontSize => _fontSize;

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSize = prefs.getString(_fontSizeKey) ?? 'Normal';
    _updateFontSize(savedSize);
  }

  void _updateFontSize(String size) {
    switch (size) {
      case 'Small':
        _fontSize = 0.8;
        break;
      case 'Normal':
        _fontSize = 1.0;
        break;
      case 'Large':
        _fontSize = 1.2;
        break;
      default:
        _fontSize = 1.0;
    }
    notifyListeners();
  }

  Future<void> setFontSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontSizeKey, size);
    _updateFontSize(size);
  }

  TextStyle getScaledTextStyle(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null ? baseStyle.fontSize! * _fontSize : null,
    );
  }
} 