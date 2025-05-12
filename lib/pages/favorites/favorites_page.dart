import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/pages/estates_page/widgets/estate_card.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/providers/estate_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final estateProvider = Provider.of<EstateProvider>(context);
    final theme = Theme.of(context);

    final favoriteEstates = estateProvider.estates
        .where((estate) => authProvider.user!.favoriteEstates.contains(estate.uid))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc!.p_favorites),
      ),
      body: favoriteEstates.isEmpty
          ? Center(
              child: Text(
                'no favorite estates', //TODO loc
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteEstates.length,
              itemBuilder: (context, index) {
                final estate = favoriteEstates[index];
                return Column(
                  children: [
                    EstateCard(
                      estate: estate,
                      isFavorite: true,
                    ),
                    if (index < favoriteEstates.length - 1)
                      Column(
                        children: [
                          SizedBox(height: 8),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: theme.dividerColor,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                  ],
                );
              },
            ),
    );
  }
}
