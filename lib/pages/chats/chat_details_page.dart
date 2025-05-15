import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_estate_app/models/message.dart';

class ChatDetailsPage extends StatefulWidget {
  final String chatId;

  ChatDetailsPage({required this.chatId});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = 'current_user'; // Mock current user ID

  // Mock messages
  final List<Message> mockMessages = [
    Message(
      id: '1',
      senderId: 'other_user',
      text: 'Hi! I saw your apartment listing.',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    Message(
      id: '2',
      senderId: 'current_user',
      text: 'Hello! Yes, it\'s still available.',
      timestamp: DateTime.now().subtract(Duration(hours: 23)),
    ),
    Message(
      id: '3',
      senderId: 'other_user',
      text: 'Great! Can I schedule a viewing?',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Message(
      id: '4',
      senderId: 'current_user',
      text: 'Of course! When would you like to come?',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Here we would normally handle the image
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected: ${image.path}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
              radius: 20,
            ),
            SizedBox(width: 8),
            Text('John Doe'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                final message = mockMessages[index];
                final isCurrentUser = message.senderId == currentUserId;

                return Align(
                  alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 8,
                      left: isCurrentUser ? 50 : 0,
                      right: isCurrentUser ? 0 : 50,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isCurrentUser 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: isCurrentUser 
                              ? Colors.white.withOpacity(0.7)
                              : theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        // Here we would normally send the message
                        if (_messageController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sending: ${_messageController.text}')),
                          );
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
} 