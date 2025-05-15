import 'package:flutter/material.dart';
import 'package:rental_estate_app/models/chat.dart';
import 'package:rental_estate_app/pages/chats/chat_details_page.dart';
import 'package:rental_estate_app/routes/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsPage extends StatelessWidget {
  // Mock data
  final List<Chat> mockChats = [
    Chat(
      id: '1',
      otherUserName: 'John Doe',
      otherUserAvatar: 'https://randomuser.me/api/portraits/men/32.jpg',
      lastMessage: 'Is this apartment still available?',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 30)),
      isUnread: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc!.p_chats),
      ),
      body: ListView.builder(
        itemCount: mockChats.length,
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ListTile(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.chatDetails,
              arguments: {'chatId': chat.id},
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.otherUserAvatar),
              radius: 25,
            ),
            title: Text(
              chat.otherUserName,
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              chat.lastMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: chat.isUnread 
                  ? theme.colorScheme.primary 
                  : theme.textTheme.bodySmall?.color,
                fontWeight: chat.isUnread ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(chat.lastMessageTime),
                  style: theme.textTheme.bodySmall,
                ),
                if (chat.isUnread)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
} 