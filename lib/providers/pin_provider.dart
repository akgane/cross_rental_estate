import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinProvider extends ChangeNotifier {
  static const String _pinKey = 'pin_entered';
  bool _isPinEntered = false;
  final SharedPreferences _prefs;

  PinProvider(this._prefs) {
    _loadPinState();
  }

  bool get isPinEntered => _isPinEntered;

  Future<void> _loadPinState() async {
    _isPinEntered = _prefs.getBool(_pinKey) ?? false;
    notifyListeners();
  }

  Future<void> setPinEntered() async {
    _isPinEntered = true;
    await _prefs.setBool(_pinKey, true);
    notifyListeners();
  }
} 