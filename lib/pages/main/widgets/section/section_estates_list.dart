import 'package:flutter/material.dart';

import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/pages/main/widgets/section/section_estate_card.dart';
import 'package:rental_estate_app/routes/app_routes.dart';

class SectionEstatesList extends StatefulWidget {
  List<Estate> estates;

  SectionEstatesList({super.key, required this.estates});

  @override
  State<StatefulWidget> createState() => _SectionEstatesListState();
}

class _SectionEstatesListState extends State<SectionEstatesList>{
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // debugPrint(widget.estates.toString());

    return Container(
      height: 200,
      margin: EdgeInsets.only(top: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.estates.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final estate = widget.estates[index];
          return SectionEstateCard(
            estate: estate,
            onTap: () => Navigator.pushNamed(context, AppRoutes.estateDetails, arguments: {'estate': estate}),
          );
        },
      ),
    );
  }

}
