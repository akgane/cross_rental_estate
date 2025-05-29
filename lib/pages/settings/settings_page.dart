import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/font_size_provider.dart';
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
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFontSize = prefs.getString('fontSize') ?? 'Normal';
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontSize', _selectedFontSize);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);
  }

  void _updateFontSize(String size) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: false);
    fontSizeProvider.setFontSize(size);
    setState(() {
      _selectedFontSize = size;
      _saveSettings();
    });
  }

  void _updateVibration(bool value) async {
    setState(() {
      _vibrationEnabled = value;
      _saveSettings();
    });
    if (value) {
      await HapticFeedback.mediumImpact();
    }
  }

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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(loc.s_help_support),
        
        ListTile(
          leading: Icon(Icons.help_outline, color: theme.iconTheme.color),
          title: Text('FAQ', style: theme.textTheme.bodyMedium),
          trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
          onTap: () => _showFAQDialog(context, theme),
        ),
        
        ListTile(
          leading: Icon(Icons.support_agent, color: theme.iconTheme.color),
          title: Text('Contact Support', style: theme.textTheme.bodyMedium),
          trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
          onTap: () => _showContactSupportDialog(context, theme),
        ),
        
        ListTile(
          leading: Icon(Icons.bug_report, color: theme.iconTheme.color),
          title: Text('Report Bug', style: theme.textTheme.bodyMedium),
          trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
          onTap: () => _showReportBugDialog(context, theme),
        ),
        
        ListTile(
          leading: Icon(Icons.privacy_tip, color: theme.iconTheme.color),
          title: Text('Privacy Policy', style: theme.textTheme.bodyMedium),
          trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
          onTap: () => _showPrivacyPolicyDialog(context, theme),
        ),
      ],
    );
  }

  void _showFAQDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Frequently Asked Questions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFAQItem('How do I list my property?', 
                'To list your property, go to the "Add Estate" section, fill in the required details, add photos, and submit. Our team will review and publish your listing.'),
              _buildFAQItem('How do I contact a property owner?',
                'You can contact property owners through the chat feature in the app. Simply go to the property details page and tap the "Contact" button.'),
              _buildFAQItem('What payment methods are accepted?',
                'We accept various payment methods including credit cards, bank transfers, and digital wallets. Payment options are displayed during the booking process.'),
              _buildFAQItem('How do I cancel a booking?',
                'You can cancel a booking through the "My Bookings" section. Please note that cancellation policies may vary depending on the property and timing.'),
              _buildFAQItem('Is my personal information secure?',
                'Yes, we take data security seriously. All personal information is encrypted and stored securely. Please refer to our Privacy Policy for more details.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(answer),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('We\'re here to help! Contact us through:'),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('support@rentalestate.com'),
              onTap: () => _launchUrl('mailto:support@rentalestate.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text('+1 (555) 123-4567'),
              onTap: () => _launchUrl('tel:+15551234567'),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Live Chat'),
              subtitle: Text('Available 24/7'),
              onTap: () {
                // Implement live chat functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportBugDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report a Bug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Help us improve by reporting any issues you encounter.'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bug Description',
                hintText: 'Please describe the issue in detail',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Your Email',
                hintText: 'We\'ll contact you for more details if needed',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement bug report submission
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thank you for your report!')),
              );
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last updated: ${DateTime.now().year}',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information We Collect',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We collect information that you provide directly to us, including your name, email address, phone number, and payment information when you use our services.',
              ),
              SizedBox(height: 16),
              Text(
                '2. How We Use Your Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We use the information we collect to provide, maintain, and improve our services, to process your transactions, and to communicate with you.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Information Sharing',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We do not share your personal information with third parties except as described in this policy.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Data Security',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We implement appropriate technical and organizational measures to protect your personal information.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final locProvider = Provider.of<LocaleProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

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
                  _updateFontSize(newValue);
                }
              },
            ),
          ),


          _buildSectionHeader(loc.s_data_usage),
          

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
              onChanged: _updateVibration,
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

          _buildHelpSection(context, theme, loc),






          _buildSectionHeader('Legal'),

          ListTile(
            leading: Icon(Icons.star, color: theme.iconTheme.color),
            title: Text(loc.s_rate_app, style: theme.textTheme.bodyMedium),
            onTap: () => _showInfoDialog(loc.s_rate_app, 'Rate our app on the app store!'),
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