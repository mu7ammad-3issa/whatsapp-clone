import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../constants/colors.dart';
import '../widgets/message_bubble.dart';
import '../widgets/animated_message_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  late AnimationController _sendButtonController;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.chat.messages);
    _generateMoreMessages(); // Add more sample messages

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  void _generateMoreMessages() {
    final now = DateTime.now();
    final additionalMessages = [
      ChatMessage(
        id: 'msg_1',
        content: 'Hello! How has your day been?',
        timestamp: now.subtract(const Duration(hours: 2)),
        isOutgoing: false,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: 'msg_2',
        content:
            'Pretty good! Just finished a big project at work. How about you?',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 2)),
        isOutgoing: true,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: 'msg_3',
        content: 'That\'s awesome! 🎉 What kind of project was it?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        isOutgoing: false,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: 'msg_4',
        content:
            'It was a mobile app redesign. Took us about 3 months to complete',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        isOutgoing: true,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: 'msg_5',
        content:
            'Wow, that sounds like a lot of work! But I bet it feels great to have it finished',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 15)),
        isOutgoing: false,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: 'msg_6',
        content:
            'Definitely! The team is planning a small celebration this weekend',
        timestamp: now.subtract(const Duration(hours: 1)),
        isOutgoing: true,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: 'msg_7',
        content: 'That sounds fun! You deserve it after all that hard work 😊',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isOutgoing: false,
        status: MessageStatus.delivered,
      ),
    ];

    _messages.insertAll(0, additionalMessages.reversed);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? WhatsAppColors.darkChatBackground
          : WhatsAppColors.lightChatBackground,
      appBar: _buildAppBar(context, isDark),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
                'https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg'),
            fit: BoxFit.cover,
            colorFilter: isDark
                ? ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.multiply)
                : null, // Add dark overlay in dark mode
            onError: (exception, stackTrace) {
              // Handle image loading errors gracefully
              debugPrint('Background image failed to load: $exception');
            },
          ),
          color: isDark
              ? WhatsAppColors.darkChatBackground
              : WhatsAppColors.lightChatBackground,
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final previousMessage = index < _messages.length - 1
                      ? _messages[_messages.length - 2 - index]
                      : null;

                  final showTimestamp = previousMessage == null ||
                      message.timestamp
                              .difference(previousMessage.timestamp)
                              .inMinutes >
                          5;

                  return Column(
                    children: [
                      if (showTimestamp)
                        _buildTimestampDivider(message.timestamp),
                      MessageBubble(
                        message: message,
                        showTail: _shouldShowTail(index),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Input Field
            AnimatedMessageInput(
              controller: _messageController,
              onSendMessage: _sendMessage,
              onTyping: () {},
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark
          ? WhatsAppColors.darkAppBarBackground
          : WhatsAppColors.lightAppBarBackground,
      elevation: 1,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Hero(
            tag: 'avatar_${widget.chat.id}',
            child: CircleAvatar(
              radius: 16,
              backgroundColor: WhatsAppColors.lightSecondary,
              backgroundImage: widget.chat.avatarUrl != null
                  ? NetworkImage(widget.chat.avatarUrl!)
                  : null,
              child: widget.chat.avatarUrl == null
                  ? Icon(
                      widget.chat.isGroup ? Icons.group : Icons.person,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
        ],
      ),
      leadingWidth: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.chat.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            _getSubtitle(),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {},
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view_contact',
              child: Text('View contact'),
            ),
            const PopupMenuItem(
              value: 'media',
              child: Text('Media, links, and docs'),
            ),
            const PopupMenuItem(
              value: 'search',
              child: Text('Search'),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Text('Mute notifications'),
            ),
            const PopupMenuItem(
              value: 'wallpaper',
              child: Text('Wallpaper'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimestampDivider(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade400)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatMessageTimestamp(timestamp),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  String _getSubtitle() {
    if (widget.chat.isGroup) {
      return '${widget.chat.participants?.length ?? 0} participants';
    } else if (widget.chat.isOnline) {
      return 'online';
    } else if (widget.chat.lastSeen != null) {
      final lastSeen = widget.chat.lastSeen!;
      final difference = DateTime.now().difference(lastSeen);

      if (difference.inMinutes < 1) {
        return 'last seen just now';
      } else if (difference.inHours < 1) {
        return 'last seen ${difference.inMinutes} minutes ago';
      } else if (difference.inDays < 1) {
        return 'last seen ${difference.inHours} hours ago';
      } else {
        return 'last seen ${DateFormat.MMMd().add_jm().format(lastSeen)}';
      }
    }
    return '';
  }

  String _formatMessageTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMd().format(timestamp);
    }
  }

  bool _shouldShowTail(int index) {
    if (index == 0) return true;

    final currentMessage = _messages[_messages.length - 1 - index];
    final nextMessage = _messages[_messages.length - index];

    return currentMessage.isOutgoing != nextMessage.isOutgoing ||
        nextMessage.timestamp.difference(currentMessage.timestamp).inMinutes >
            2;
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      timestamp: DateTime.now(),
      isOutgoing: true,
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Trigger send animation
    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate message status updates
    _simulateMessageStatusUpdates(newMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _simulateMessageStatusUpdates(ChatMessage message) {
    // Simulate message being sent
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        message.status = MessageStatus.sent;
      });
    });

    // Simulate message being delivered
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        message.status = MessageStatus.delivered;
      });
    });

    // Simulate message being read (sometimes)
    if (DateTime.now().millisecond % 2 == 0) {
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          message.status = MessageStatus.read;
        });
      });
    }
  }
}
