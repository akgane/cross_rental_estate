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

    Widget _buildSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc!.s_settings),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(loc.s_app_preferences),
          
          // Display Settings
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text(loc.s_dark_mode, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: themeProvider.currentTheme == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(context),
            ),
          ),
          ListTile(
            leading: Icon(Icons.font_download),
            title: Text(loc.s_font_size, style: theme.textTheme.bodyMedium),
            trailing: DropdownButton<String>(
              value: 'Normal',
              items: ['Small', 'Normal', 'Large'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // TODO: Implement font size change
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.animation),
            title: Text(loc.s_animations, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement animations toggle
              },
            ),
          ),

          _buildSectionHeader(loc.s_data_usage),
          
          ListTile(
            leading: Icon(Icons.offline_bolt),
            title: Text(loc.s_offline_mode, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {
                // TODO: Implement offline mode
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text(loc.s_auto_download, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement auto download
              },
            ),
          ),

          _buildSectionHeader(loc.s_notifications_settings),
          
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(loc.s_push_notifications, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement push notifications
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(loc.s_email_notifications, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {
                // TODO: Implement email notifications
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text(loc.s_chat_notifications, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement chat notifications
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text(loc.s_sound, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement sound toggle
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vibration),
            title: Text(loc.s_vibration, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // TODO: Implement vibration toggle
              },
            ),
          ),

          _buildSectionHeader(loc.s_security),
          
          ListTile(
            leading: Icon(Icons.fingerprint),
            title: Text(loc.s_biometric, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {
                // TODO: Implement biometric auth
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text(loc.s_two_factor, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {
                // TODO: Implement 2FA
              },
            ),
          ),

          _buildSectionHeader(loc.s_language),
          
          ListTile(
            leading: Icon(Icons.language),
            title: Text(loc.s_language, style: theme.textTheme.bodyMedium),
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
                      LanguageListTile(
                        title: 'English',
                        locale: 'en',
                        locProvider: locProvider,
                        themeProvider: themeProvider,
                        authProvider: authProvider,
                      ),
                      LanguageListTile(
                        title: 'Русский',
                        locale: 'ru',
                        locProvider: locProvider,
                        themeProvider: themeProvider,
                        authProvider: authProvider,
                      ),
                      LanguageListTile(
                        title: 'Қазақша',
                        locale: 'kk',
                        locProvider: locProvider,
                        themeProvider: themeProvider,
                        authProvider: authProvider,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          _buildSectionHeader(loc.s_help_support),
          
          ListTile(
            leading: Icon(Icons.help),
            title: Text(loc.s_faq, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_faq, 'Frequently asked questions and answers will be displayed here.'),
          ),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text(loc.s_contact, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_contact, 'Contact our support team at support@example.com'),
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text(loc.s_report_bug, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_report_bug, 'Report any issues or bugs you encounter while using the app.'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text(loc.s_rate_app, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_rate_app, 'Rate our app on the app store!'),
          ),

          _buildSectionHeader('Legal'),
          
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text(loc.s_privacy, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(
              loc.s_privacy,
              'This application does not collect, store, or share any personal data. Your privacy is our priority.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(loc.s_about, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(
              loc.s_about,
              'This is a rental management application developed to simplify property management. Version 1.0.0',
            ),
          ),

          SizedBox(height: 24),
        ],
      ),
    );
  }
}