import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:rental_estate_app/routes/app_routes.dart';

class MyBottomAppBar extends StatelessWidget{
  bool isGuest;

  MyBottomAppBar({super.key, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () async{
            final ImagePicker picker = ImagePicker();
            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
          }),

          IconButton(icon: Icon(Icons.favorite, color: (isGuest ? theme.disabledColor : theme.iconTheme.color),), onPressed: isGuest ? null : () => Navigator.pushNamed(context, AppRoutes.favorites)),

          SizedBox(width: 40,),

          IconButton(icon: Icon(Icons.message, color: (isGuest ? theme.disabledColor : theme.iconTheme.color)), onPressed: isGuest ? null : () => debugPrint('opening messages page')),

          IconButton(icon: Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),)
        ]
      )
    );
  }
}