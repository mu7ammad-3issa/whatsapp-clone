import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../constants/colors.dart';

class ChatTile extends StatefulWidget {
  final Chat chat;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.01, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.selectionClick();
  }

  void _onTapUp(TapUpDetails details) {
    _onTapCancel();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.chat.isPinned
                      ? (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05))
                      : null,
                ),
                child: Row(
                  children: [
                    // Profile Avatar with better styling
                    Stack(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                            backgroundImage: widget.chat.avatarUrl != null
                                ? NetworkImage(widget.chat.avatarUrl!)
                                : null,
                            child: widget.chat.avatarUrl == null
                                ? Icon(
                                    widget.chat.isGroup
                                        ? Icons.group
                                        : Icons.person,
                                    color: Colors.white,
                                    size: 28,
                                  )
                                : null,
                          ),
                        ),
                        if (widget.chat.isOnline && !widget.chat.isGroup)
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: WhatsAppColors.online,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 15),

                    // Chat Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Chat Name with better styling
                              Expanded(
                                child: Row(
                                  children: [
                                    if (widget.chat.isPinned) ...[
                                      Icon(
                                        Icons.push_pin,
                                        size: 14,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Expanded(
                                      child: Text(
                                        widget.chat.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Timestamp with better formatting
                              Text(
                                _formatTimestamp(widget.chat.lastMessageTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.chat.unreadCount > 0
                                      ? WhatsAppColors.primaryGreen
                                      : (isDark
                                          ? Colors.white54
                                          : Colors.black54),
                                  fontWeight: widget.chat.unreadCount > 0
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              // Last Message with read status
                              Expanded(
                                child: Row(
                                  children: [
                                    // Show read status for outgoing messages
                                    if (widget.chat.lastMessageObject
                                            ?.isOutgoing ==
                                        true) ...[
                                      Icon(
                                        widget.chat.lastMessageObject?.status ==
                                                MessageStatus.read
                                            ? Icons.done_all
                                            : widget.chat.lastMessageObject
                                                        ?.status ==
                                                    MessageStatus.delivered
                                                ? Icons.done_all
                                                : Icons.done,
                                        size: 16,
                                        color: widget.chat.lastMessageObject
                                                    ?.status ==
                                                MessageStatus.read
                                            ? WhatsAppColors.seenCheckmark
                                            : (isDark
                                                ? Colors.white54
                                                : Colors.black54),
                                      ),
                                      const SizedBox(width: 3),
                                    ],

                                    Expanded(
                                      child: Text(
                                        widget.chat.lastMessage,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: widget.chat.unreadCount > 0
                                              ? (isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                              : (isDark
                                                  ? Colors.white70
                                                  : Colors.black54),
                                          fontWeight:
                                              widget.chat.unreadCount > 0
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Status Icons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.chat.isMuted)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Icon(
                                        Icons.volume_off,
                                        size: 16,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                    ),
                                  if (widget.chat.unreadCount > 0)
                                    Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: WhatsAppColors.unreadCount,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        widget.chat.unreadCount > 999
                                            ? '999+'
                                            : widget.chat.unreadCount
                                                .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today - show time in 12-hour format
      return DateFormat.jm().format(timestamp);
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      return DateFormat.E().format(timestamp);
    } else if (difference.inDays < 365) {
      // This year - show date without year
      return DateFormat.MMMd().format(timestamp);
    } else {
      // Older - show full date
      return DateFormat.yMMMd().format(timestamp);
    }
  }
}
