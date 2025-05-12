import 'package:flutter/material.dart';

import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';

class LanguageListTile extends StatelessWidget{
  final String title;
  final String locale;
  final LocaleProvider locProvider;
  final ThemeProvider themeProvider;
  final AuthProvider authProvider;

  const LanguageListTile({
    super.key,
    required this.title,
    required this.locale,
    required this.locProvider,
    required this.themeProvider,
    required this.authProvider
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        onTap: (){
          locProvider.setLocale(Locale(locale));
          authProvider.updateUserInfo();
          Navigator.of(context).pop();
        }
    );
  }
}
