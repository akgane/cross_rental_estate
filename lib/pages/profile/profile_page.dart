import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/providers/theme_provider.dart';
import 'package:rental_estate_app/providers/locale_provider.dart';
import 'package:rental_estate_app/routes/app_routes.dart';


class ProfilePage extends StatelessWidget{
  String _getLocalizedLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'kk':
        return 'Қазақша';
      default:
        return languageCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.auth);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.white)), //TODO loc
          backgroundColor: theme.colorScheme.primary,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                      tag: 'profile-avatar',
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatarUrl),
                        radius: 100,
                      )
                  ),
                  SizedBox(height: 24,),
                  Text(
                      user.username,
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)
                  ),
                  SizedBox(height: 12,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.email, color: theme.iconTheme.color),
                          title: Text('Email', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                          subtitle: Text(user.email, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                        ),
                        Divider(color: Colors.white24),
                        ListTile(
                          leading: Icon(Icons.language, color: theme.iconTheme.color),
                          title: Text('Language', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                          subtitle: Text(_getLocalizedLanguageName(localeProvider.currentLocale.languageCode), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                        ),
                        Divider(color: Colors.white24),
                        ListTile(
                          leading: Icon(Icons.palette, color: theme.iconTheme.color),
                          title: Text('Theme', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                          subtitle: Text(themeProvider.currentTheme == ThemeMode.dark ? 'Dark' : 'Light', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  IconButton(
                    icon: Icon(Icons.logout, color: theme.iconTheme.color),
                    onPressed: () async{
                      Navigator.pushReplacementNamed(context, AppRoutes.auth);
                      await authProvider.signOut();
                    },
                  )
                ]
            ),
          ),
        )
    );
  }
}