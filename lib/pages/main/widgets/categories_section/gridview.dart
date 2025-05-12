import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_estate_app/models/category.dart';
import 'package:rental_estate_app/pages/main/widgets/categories_section/category_button.dart';

class CategoriesGridView extends StatelessWidget {
  List<Category> categories;

  CategoriesGridView({super.key, required this.categories});

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
            onTap: () => print("opening ${category.title} section"),
          );
        }).toList()
    );
  }
}
