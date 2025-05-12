import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/pages/main/widgets/section/section_estates_list.dart';
import 'package:rental_estate_app/pages/main/widgets/section/section_header.dart';
import 'package:rental_estate_app/routes/app_routes.dart';

class Section extends StatelessWidget {
  String title;
  List<Estate> estates;

  Section({super.key, required this.title, required this.estates});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAllPressed:
              () => Navigator.pushNamed(
                context,
                AppRoutes.estatesList,
                arguments: {'title': title, 'estates': estates},
              ),
        ),
        SizedBox(height: 8),
        SectionEstatesList(estates: estates),
      ],
    );
  }
}
