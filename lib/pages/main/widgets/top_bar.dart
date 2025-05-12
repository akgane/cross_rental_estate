import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/pages/main/widgets/top_bar_widgets/avatar.dart';
import 'package:rental_estate_app/pages/main/widgets/top_bar_widgets/user_info.dart';

class TopBar extends StatefulWidget{
  final String username;
  final String avatarUrl;

  const TopBar({
    required this.username,
    required this.avatarUrl,
  });

  @override
  State<StatefulWidget> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar>{
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(avatarUrl: widget.avatarUrl),
        SizedBox(width: 12,),
        UserInfo(username: widget.username),
      ],
    );
  }
}