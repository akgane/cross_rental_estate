import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_list_tile.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables for all interactive elements
  String _selectedFontSize = 'Normal';
  bool _animationsEnabled = true;
  bool _offlineMode = false;
  bool _autoDownload = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _chatNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;

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
            leading: Icon(Icons.dark_mode, color: theme.iconTheme.color),
            title: Text(loc.s_dark_mode, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: themeProvider.currentTheme == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(context),
            ),
          ),
          ListTile(
            leading: Icon(Icons.font_download, color: theme.iconTheme.color),
            title: Text(loc.s_font_size, style: theme.textTheme.bodyMedium),
            trailing: DropdownButton<String>(
              value: _selectedFontSize,
              items: ['Small', 'Normal', 'Large'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFontSize = newValue;
                  });
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.animation, color: theme.iconTheme.color),
            title: Text(loc.s_animations, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _animationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _animationsEnabled = value;
                });
              },
            ),
          ),

          _buildSectionHeader(loc.s_data_usage),
          
          ListTile(
            leading: Icon(Icons.offline_bolt, color: theme.iconTheme.color),
            title: Text(loc.s_offline_mode, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _offlineMode,
              onChanged: (bool value) {
                setState(() {
                  _offlineMode = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.image, color: theme.iconTheme.color),
            title: Text(loc.s_auto_download, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _autoDownload,
              onChanged: (bool value) {
                setState(() {
                  _autoDownload = value;
                });
              },
            ),
          ),

          _buildSectionHeader(loc.s_notifications_settings),
          
          ListTile(
            leading: Icon(Icons.notifications, color: theme.iconTheme.color),
            title: Text(loc.s_push_notifications, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: theme.iconTheme.color),
            title: Text(loc.s_email_notifications, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.chat, color: theme.iconTheme.color),
            title: Text(loc.s_chat_notifications, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _chatNotifications,
              onChanged: (bool value) {
                setState(() {
                  _chatNotifications = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.volume_up, color: theme.iconTheme.color),
            title: Text(loc.s_sound, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _soundEnabled,
              onChanged: (bool value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vibration, color: theme.iconTheme.color),
            title: Text(loc.s_vibration, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _vibrationEnabled,
              onChanged: (bool value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              },
            ),
          ),

          _buildSectionHeader(loc.s_security),
          
          ListTile(
            leading: Icon(Icons.fingerprint, color: theme.iconTheme.color),
            title: Text(loc.s_biometric, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _biometricEnabled,
              onChanged: (bool value) {
                setState(() {
                  _biometricEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.security, color: theme.iconTheme.color),
            title: Text(loc.s_two_factor, style: theme.textTheme.bodyMedium),
            trailing: Switch(
              value: _twoFactorEnabled,
              onChanged: (bool value) {
                setState(() {
                  _twoFactorEnabled = value;
                });
              },
            ),
          ),

          _buildSectionHeader(loc.s_language),
          
          ListTile(
            leading: Icon(Icons.language, color: theme.iconTheme.color),
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
            leading: Icon(Icons.help, color: theme.iconTheme.color),
            title: Text(loc.s_faq, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_faq, 'Frequently asked questions and answers will be displayed here.'),
          ),
          ListTile(
            leading: Icon(Icons.contact_support, color: theme.iconTheme.color),
            title: Text(loc.s_contact, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_contact, 'Contact our support team at support@example.com'),
          ),
          ListTile(
            leading: Icon(Icons.bug_report, color: theme.iconTheme.color),
            title: Text(loc.s_report_bug, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_report_bug, 'Report any issues or bugs you encounter while using the app.'),
          ),
          ListTile(
            leading: Icon(Icons.star, color: theme.iconTheme.color),
            title: Text(loc.s_rate_app, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_rate_app, 'Rate our app on the app store!'),
          ),

          _buildSectionHeader('Legal'),
          
          ListTile(
            leading: Icon(Icons.privacy_tip, color: theme.iconTheme.color),
            title: Text(loc.s_privacy, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(
              loc.s_privacy,
              'This application does not collect, store, or share any personal data. Your privacy is our priority.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.info, color: theme.iconTheme.color),
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