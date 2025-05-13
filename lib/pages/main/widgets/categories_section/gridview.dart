import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_estate_app/models/category.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/pages/main/widgets/categories_section/category_button.dart';
import 'package:rental_estate_app/routes/app_routes.dart';

class CategoriesGridView extends StatelessWidget {
  List<Category> categories;
  List<Estate> estates;

  CategoriesGridView({super.key, required this.categories, required this.estates});

  @override
  Widget build(BuildContext context) {


    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: categories.map((category) {
          return CategoryButton(
            title: category.title,
            icon: category.icon,
            onTap: () => Navigator.pushNamed(context, AppRoutes.estatesList, arguments: {
              'title': category.title,
              'estates': getCategoryEstates(category.title)
            }),
          );
        }).toList()
    );
  }

  List<Estate> getCategoryEstates(String category){
    return estates.where((estate) => estate.category == category).toList();
  }
}
