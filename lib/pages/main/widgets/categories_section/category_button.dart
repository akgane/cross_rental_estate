import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  CategoryButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.cardColor
            ),
            child: Icon(
                icon,
                color: theme.iconTheme.color
            ),
          ),

          SizedBox(height: 4),

          Flexible(
            child: Text(
                title,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}