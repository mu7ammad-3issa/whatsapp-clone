import 'message.dart';

class Chat {
  final String id;
  final String name;
  final String? avatarUrl;
  final List<ChatMessage> messages;
  final DateTime lastMessageTime;
  final String lastMessage;
  final int unreadCount;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool isPinned;
  final bool isMuted;
  final bool isGroup;
  final List<String>? participants;

  Chat({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.messages,
    required this.lastMessageTime,
    required this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
    this.lastSeen,
    this.isPinned = false,
    this.isMuted = false,
    this.isGroup = false,
    this.participants,
  });

  ChatMessage? get lastMessageObject => messages.isNotEmpty ? messages.last : null;
}
