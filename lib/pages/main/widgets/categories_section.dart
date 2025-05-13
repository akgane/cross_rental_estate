import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_estate_app/models/category.dart';
import 'package:rental_estate_app/models/estate.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rental_estate_app/pages/main/widgets/categories_section/gridview.dart';

class CategoriesSection extends StatelessWidget {
  List<Estate> estates;
  List<Category> categories;

  CategoriesSection({super.key, required this.estates, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            AppLocalizations.of(context)!.m_categories,
            style: theme.textTheme.titleLarge,
          ),
        ),

        CategoriesGridView(categories: categories, estates: estates)
      ],
    );
  }
}
