import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/routes/app_routes.dart';
import 'package:rental_estate_app/widgets/estate_image.dart';

class EstateCard extends StatefulWidget{
  Estate estate;
  bool isFavorite;

  EstateCard({super.key, required this.estate, required this.isFavorite});

  @override
  State<StatefulWidget> createState() => _EstateCardState();
}

class _EstateCardState extends State<EstateCard>{
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.estateDetails, arguments: {'estate': widget.estate});
      },
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(EstateCardStyles.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: EstateCardStyles.paddingAll),

                    _buildImage(context),

                    SizedBox(width: EstateCardStyles.paddingAll),

                    _buildDetails(context),

                    _buildFavoriteButton(context)
                  ]
              ),

              Padding(
                  padding: const EdgeInsets.all(EstateCardStyles.paddingAll),
                  child: _buildViewsCounter(context)
              )
            ],
          ),
        )
    );
  }

  void _toggleFavorite(){
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if(authProvider.isGuest) return;

    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });

    if (widget.isFavorite) {
      authProvider.user!.favoriteEstates.add(widget.estate.uid);
    } else {
      authProvider.user!.favoriteEstates.remove(widget.estate.uid);
    }

    authProvider.updateUserInfo();
  }

  Widget _buildTitle(BuildContext context){
    return Padding(
        padding: const EdgeInsets.all(EstateCardStyles.paddingAll),
        child: Text(
            widget.estate.title,
            style: Theme.of(context).textTheme.titleMedium
        )
    );
  }

  Widget _buildImage(BuildContext context){
    return EstateImage(
      imageUrl: widget.estate.imageUrls[0],
      width: EstateCardStyles.imageWidth,
      height: EstateCardStyles.imageHeight,
      borderRadius: BorderRadius.circular(EstateCardStyles.borderRadius),
    );
  }

  Widget _buildDetails(BuildContext context){
    final theme = Theme.of(context);
    return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.estate.address,
                style: theme.textTheme.bodySmall,
              ),

              SizedBox(height: EstateCardStyles.spacingMedium),

              Text(
                  '\$${widget.estate.price}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary
                  )
              )
            ]
        )
    );
  }

  Widget _buildViewsCounter(BuildContext context){
    final theme = Theme.of(context);

    return Row(
        children: [
          Icon(
              Icons.visibility,
              size: EstateCardStyles.iconSize,
              color: theme.textTheme.bodySmall?.color
          ),

          SizedBox(width: EstateCardStyles.spacingSmall,),

          Text(
              '${widget.estate.views} views',
              style: theme.textTheme.bodySmall
          )
        ]
    );
  }

  Widget _buildFavoriteButton(BuildContext context){
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return IconButton(
      icon: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite
              ? theme.colorScheme.error
              : theme.iconTheme.color
      ),
      onPressed: authProvider.isGuest ? null : _toggleFavorite,
    );
  }
}

class EstateCardStyles {
  static const double cardMarginBottom = 16;
  static const double borderRadius = 12;
  static const double imageWidth = 190;
  static const double imageHeight = 120;
  static const double iconSize = 16;
  static const double paddingAll = 12;
  static const double spacingSmall = 4;
  static const double spacingMedium = 8;
}
