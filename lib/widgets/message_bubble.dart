import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../constants/colors.dart';
import '../utils/responsive_helper.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTail;

  const MessageBubble({
    super.key,
    required this.message,
    this.showTail = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment:
          message.isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxChatWidth(context),
        ),
        margin: EdgeInsets.only(
          left: message.isOutgoing
              ? screenWidth * 0.25
              : ResponsiveHelper.getHorizontalPadding(context).left,
          right: message.isOutgoing
              ? ResponsiveHelper.getHorizontalPadding(context).right
              : screenWidth * 0.25,
          top: showTail ? 6 : 2,
          bottom: 2,
        ),
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: _getBubbleColor(isDark),
              borderRadius:
                  ResponsiveHelper.getResponsiveBorderRadius(context).copyWith(
                bottomLeft: Radius.circular(
                    message.isOutgoing ? 12 : (showTail ? 4 : 12)),
                bottomRight: Radius.circular(
                    message.isOutgoing ? (showTail ? 4 : 12) : 12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  offset: const Offset(0, 1),
                  blurRadius: ResponsiveHelper.getElevation(context, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Message content with adaptive width
                Container(
                  constraints: BoxConstraints(
                    minWidth: _getMinimumWidth(),
                  ),
                  width: double.infinity,
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, 15),
                      height: 1.4,
                      color: message.isOutgoing
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Timestamp and status row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.jm().format(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: message.isOutgoing
                            ? (isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.6))
                            : (isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    if (message.isOutgoing) ...[
                      const SizedBox(width: 4),
                      _buildMessageStatusIcon(isDark),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Get adaptive horizontal padding based on text length
  double _getHorizontalPadding() {
    final textLength = message.content.length;
    if (textLength <= 20) {
      return 12.0; // Short messages get standard padding
    } else if (textLength <= 50) {
      return 14.0; // Medium messages get slightly more padding
    } else {
      return 16.0; // Long messages get more padding for better readability
    }
  }

  // Get adaptive vertical padding
  double _getVerticalPadding() {
    final hasMultipleLines =
        message.content.contains('\n') || message.content.length > 40;
    return hasMultipleLines ? 10.0 : 8.0;
  }

  // Get minimum width based on content
  double _getMinimumWidth() {
    final textLength = message.content.length;
    if (textLength <= 5) {
      return 40.0; // Very short messages (like "Hi", "OK")
    } else if (textLength <= 15) {
      return 60.0; // Short messages
    } else {
      return 0.0; // Let longer messages size naturally
    }
  }

  Color _getBubbleColor(bool isDark) {
    if (message.isOutgoing) {
      return isDark
          ? WhatsAppColors.outgoingMessageDark
          : WhatsAppColors.outgoingMessageLight;
    } else {
      return isDark
          ? WhatsAppColors.incomingMessageDark
          : WhatsAppColors.incomingMessageLight;
    }
  }

  Widget _buildMessageStatusIcon(bool isDark) {
    IconData iconData;
    Color iconColor = isDark ? Colors.white70 : Colors.black54;

    switch (message.status) {
      case MessageStatus.sending:
        iconData = Icons.access_time;
        iconColor = isDark ? Colors.white38 : Colors.black38;
        break;
      case MessageStatus.sent:
        iconData = Icons.done;
        iconColor = isDark ? Colors.white54 : Colors.black54;
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        iconColor = isDark ? Colors.white54 : Colors.black54;
        break;
      case MessageStatus.read:
        iconData = Icons.done_all;
        iconColor = WhatsAppColors.seenCheckmark;
        break;
    }

    return Icon(
      iconData,
      size: 16,
      color: iconColor,
    );
  }
}

class BubblePainter extends CustomPainter {
  final bool isOutgoing;
  final Color color;

  BubblePainter({
    required this.isOutgoing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isOutgoing) {
      // Outgoing message bubble (right side with tail)
      path.moveTo(0, 8);
      path.quadraticBezierTo(0, 0, 8, 0);
      path.lineTo(size.width - 8, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 8);
      path.lineTo(size.width, size.height - 8);
      path.quadraticBezierTo(
          size.width, size.height, size.width - 8, size.height);
      path.lineTo(size.width - 4, size.height);
      path.quadraticBezierTo(
          size.width + 2, size.height - 4, size.width + 6, size.height - 8);
      path.lineTo(8, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - 8);
      path.close();
    } else {
      // Incoming message bubble (left side with tail)
      path.moveTo(8, 0);
      path.lineTo(size.width - 8, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 8);
      path.lineTo(size.width, size.height - 8);
      path.quadraticBezierTo(
          size.width, size.height, size.width - 8, size.height);
      path.lineTo(8, size.height);
      path.lineTo(4, size.height);
      path.quadraticBezierTo(-2, size.height - 4, -6, size.height - 8);
      path.lineTo(0, 8);
      path.quadraticBezierTo(0, 0, 8, 0);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
