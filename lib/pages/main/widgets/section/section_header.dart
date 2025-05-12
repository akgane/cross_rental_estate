import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SectionHeader extends StatelessWidget{
  String title;
  VoidCallback onSeeAllPressed;

  SectionHeader({super.key, required this.title, required this.onSeeAllPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge
        ),
        GestureDetector(
          onTap: onSeeAllPressed,
          child: Text(
            AppLocalizations.of(context)!.m_see_all,
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)
          )
        )
      ]
    );
  }

}