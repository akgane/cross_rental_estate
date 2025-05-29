import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/widgets/estate_image.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rental_estate_app/providers/auth_provider.dart' as AP;
import 'package:rental_estate_app/utils/extensions.dart';


class EstateDetailsPage extends StatefulWidget{
  Estate estate;

  EstateDetailsPage({super.key, required this.estate});

  @override
  State<StatefulWidget> createState() => _EstateDetailsState();
}

class _EstateDetailsState extends State<EstateDetailsPage>{
  bool isFavorite = false;
  late GoogleMapController mapController;
  LatLng _center = LatLng(37.7749, -122.4194);
  bool _didInitFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitFavorite) {
      _checkFavoriteStatus();
      _didInitFavorite = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkFavoriteStatus() async{
    final authProvider = Provider.of<AP.AuthProvider>(context);
    final status = authProvider.isGuest ? false : (authProvider.user!.favoriteEstates.contains(widget.estate.uid));
    setState(() {
      isFavorite = status;
    });
  }

  Future<void> _toggleFavorite() async{
    final authProvider = Provider.of<AP.AuthProvider>(context, listen: false);
    
    if(authProvider.isGuest) return;

    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      authProvider.user!.favoriteEstates.add(widget.estate.uid);
    } else {
      authProvider.user!.favoriteEstates.remove(widget.estate.uid);
    }

    await authProvider.updateUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final authProvider = Provider.of<AP.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.estate.title,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4,),
            Text(
              widget.estate.uid.substring(0, 5),
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? theme.colorScheme.error : theme.iconTheme.color,
            ),
            onPressed: authProvider.isGuest ? null : _toggleFavorite,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: EstateImage(
                imageUrl: widget.estate.imageUrls[0],
                height: 250,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16),

            Text(
              widget.estate.title,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 8),

            Text(
              "\$${widget.estate.price}",
              style: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16),

            Text(
              loc!.e_description,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              "This is a detailed description of the property. It includes information about the location, amenities, and unique features of the estate.",
              style: theme.textTheme.bodySmall,
            ),
            SizedBox(height: 16),
            Text(
              loc.e_details,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            _buildFeaturesTable(),
            SizedBox(height: 16),
            Text(
              loc.e_on_map,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTable(){
    final theme = Theme.of(context);
    return Column(
      children: widget.estate.features.entries.map((entry){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.key.capitalize().removeUnderscore(),
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              entry.value.toString().capitalize(),
              style: theme.textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}