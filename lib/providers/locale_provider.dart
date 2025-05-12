import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';

class LocaleProvider with ChangeNotifier{
  Locale _locale = const Locale('en');

  Locale get currentLocale => _locale;

  // Инициализация без уведомления слушателей
  void initLocale(Locale locale) {
    if(!['en', 'ru', 'kk'].contains(locale.languageCode)) return;
    _locale = locale;
  }

  // Изменение локали с уведомлением и сохранением
  void setLocale(Locale locale, [BuildContext? context]){
    if(!['en', 'ru', 'kk'].contains(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();

    if (context != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null && !authProvider.isGuest) {
        authProvider.user!.language = locale.languageCode;
        authProvider.updateUserInfo();
      }
    }
  }
}