import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/providers/session_provider.dart';
import 'package:rental_estate_app/routes/app_routes.dart';


class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final authProvider = Provider.of<AuthProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
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

    Future<void> handleLogout() async {
      await sessionProvider.logout();
      await authProvider.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.auth,
          (route) => false,
        );
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile'), //TODO loc
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Center(
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
              style: theme.textTheme.titleLarge
            ),
            SizedBox(height: 12,),
            Text(
              "Hello User ! \n"
                  "Its your profile page", //TODO loc
              style: theme.textTheme.bodyMedium,
            ),
            IconButton(
              icon: Icon(Icons.logout, color: theme.iconTheme.color),
              onPressed: handleLogout,
            )
          ]
        )
      )
    );
  }
}