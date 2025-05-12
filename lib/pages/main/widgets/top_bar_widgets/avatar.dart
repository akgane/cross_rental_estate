import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/routes/app_routes.dart';

class Avatar extends StatelessWidget {
  String avatarUrl;

  Avatar({
    super.key,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    bool isGuest = authProvider.isGuest;

    return GestureDetector(
        onTap: (){
          debugPrint('opening other page. isGuest = $isGuest');
          Navigator.pushNamed(context, isGuest ? AppRoutes.auth : AppRoutes.profile);
        },
        child: Hero(
            tag: 'profile-avatar',
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 20,
            )
        )
    );
  }
}