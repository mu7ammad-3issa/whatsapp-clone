import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../widgets/chat_tile.dart';
import '../widgets/animated_transitions.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final List<Chat> _chats = _generateMockChats();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Archive button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.archive_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 16),
              Text(
                'Archived',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Chat list
        Expanded(
          child: ListView.builder(
            itemCount: _chats.length,
            itemBuilder: (context, index) {
              final chat = _chats[index];
              return ChatTile(
                chat: chat,
                onTap: () {
                  Navigator.of(context).push(
                    ChatPageTransition(
                      child: ChatDetailScreen(chat: chat),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  static List<Chat> _generateMockChats() {
    final now = DateTime.now();

    return [
      Chat(
        id: '1',
        name: 'Alice Johnson',
        lastMessage: 'Hey! How are you doing?',
        lastMessageTime: now.subtract(const Duration(minutes: 5)),
        unreadCount: 3,
        isOnline: true,
        messages: [
          ChatMessage(
            id: '1',
            content: 'Hey! How are you doing?',
            timestamp: now.subtract(const Duration(minutes: 5)),
            isOutgoing: false,
            status: MessageStatus.delivered,
          ),
        ],
      ),
      Chat(
        id: '2',
        name: 'Bob Smith',
        lastMessage: 'Perfect! See you tomorrow 👍',
        lastMessageTime: now.subtract(const Duration(hours: 2)),
        unreadCount: 0,
        isOnline: false,
        lastSeen: now.subtract(const Duration(hours: 1)),
        messages: [
          ChatMessage(
            id: '2',
            content: 'Perfect! See you tomorrow 👍',
            timestamp: now.subtract(const Duration(hours: 2)),
            isOutgoing: true,
            status: MessageStatus.read,
          ),
        ],
      ),
      Chat(
        id: '3',
        name: 'Family Group',
        lastMessage: 'Mom: Don\'t forget about dinner tonight',
        lastMessageTime: now.subtract(const Duration(hours: 4)),
        unreadCount: 1,
        isGroup: true,
        participants: ['mom', 'dad', 'sister'],
        messages: [
          ChatMessage(
            id: '3',
            content: 'Don\'t forget about dinner tonight',
            timestamp: now.subtract(const Duration(hours: 4)),
            isOutgoing: false,
            status: MessageStatus.delivered,
          ),
        ],
      ),
      Chat(
        id: '4',
        name: 'Carol Davis',
        lastMessage: 'Thanks for your help! 😊',
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: false,
        lastSeen: now.subtract(const Duration(hours: 12)),
        messages: [
          ChatMessage(
            id: '4',
            content: 'Thanks for your help! 😊',
            timestamp: now.subtract(const Duration(days: 1)),
            isOutgoing: false,
            status: MessageStatus.delivered,
          ),
        ],
      ),
      Chat(
        id: '5',
        name: 'Work Team',
        lastMessage: 'David: Meeting rescheduled to 3 PM',
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 5,
        isGroup: true,
        participants: ['david', 'sarah', 'mike', 'lisa'],
        isPinned: true,
        messages: [
          ChatMessage(
            id: '5',
            content: 'Meeting rescheduled to 3 PM',
            timestamp: now.subtract(const Duration(days: 1)),
            isOutgoing: false,
            status: MessageStatus.delivered,
          ),
        ],
      ),
    ];
  }
}
