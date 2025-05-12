import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_list_tile.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final locProvider = Provider.of<LocaleProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    void _showInfoDialog(String title, String content) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc!.s_settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                loc.s_dark_mode,
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Switch(
                value: themeProvider.currentTheme == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(context);
                },
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.language, color: theme.iconTheme.color),
                  SizedBox(width: 8),
                  Text(loc.s_language, style: theme.textTheme.bodyMedium),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.language, color: theme.iconTheme.color),
                            SizedBox(width: 8),
                            Text(loc.s_language, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LanguageListTile(title: 'English', locale: 'en', locProvider: locProvider, themeProvider: themeProvider, authProvider: authProvider,),
                              LanguageListTile(title: 'Русский', locale: 'ru', locProvider: locProvider, themeProvider: themeProvider, authProvider: authProvider,),
                              LanguageListTile(title: 'Қазақша', locale: 'kk', locProvider: locProvider, themeProvider: themeProvider, authProvider: authProvider,),
                            ]
                        )
                    )
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                loc.s_notifications,
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: реализовать
                },
              ),
            ),
            // ListTile(
            //   title: Text(loc.s_account_settings, style: theme.textTheme.bodyMedium),
            //   trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
            //   onTap: () {
            //     // TODO: реализовать переход
            //   },
            // ),
            ListTile(
              title: Text(loc.s_privacy, style: theme.textTheme.bodyMedium),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
              onTap: () {
                _showInfoDialog(loc.s_privacy, 'This application does not collect, store, or share any personal data. Your privacy is our priority.');
              },
            ),
            ListTile(
              title: Text(loc.s_about, style: theme.textTheme.bodyMedium),
              trailing: Icon(Icons.info_outline, color: theme.iconTheme.color),
              onTap: () {
                _showInfoDialog(loc.s_about, 'This is a rental management application developed to simplify property management. Version 1.0.0.');
              },
            ),
          ],
        ),
      ),
    );
  }
}