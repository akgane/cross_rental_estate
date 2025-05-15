import 'package:flutter/material.dart';
import 'package:rental_estate_app/pages/auth/auth_page.dart';
import 'package:rental_estate_app/pages/chats/chat_details_page.dart';
import 'package:rental_estate_app/pages/chats/chats_page.dart';
import 'package:rental_estate_app/pages/estate_details/estate_details_page.dart';
import 'package:rental_estate_app/pages/favorites/favorites_page.dart';
import 'package:rental_estate_app/pages/profile/profile_page.dart';
import 'package:rental_estate_app/pages/settings/settings_page.dart';

import '../main.dart';
import '../pages/estates_page/estates_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = (settings.arguments != null) ? (settings.arguments as Map<String, dynamic>) : null;

    switch (settings.name) {
      case AppRoutes.auth:
        return MaterialPageRoute(
            builder: (_) => AuthPage()
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
            builder: (_) => ProfilePage()
        );
      case AppRoutes.estatesList:
        return MaterialPageRoute(
            builder: (_) => EstatesPage(
              title: args?['title'],
              estates: args?['estates'],
            )
        );
      case AppRoutes.estateDetails:
        return MaterialPageRoute(
          builder: (_) => EstateDetailsPage(estate: args?['estate'])
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsPage()
        );
      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => FavoritesPage()
        );
      case AppRoutes.chats:
        return MaterialPageRoute(
          builder: (_) => ChatsPage()
        );
      case AppRoutes.chatDetails:
        return MaterialPageRoute(
          builder: (_) => ChatDetailsPage(chatId: args?['chatId'])
        );
      case AppRoutes.home:
      default:
        return MaterialPageRoute(
          builder: (_) => MainPage(guestMode: args?['guestMode'] ?? false)
        );
    }
  }
}